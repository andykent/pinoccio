module Pinoccio
  module Commands
    def lead?
      @is_lead ||= get("scout.isleadscout", :boolean)
    end

    def report
      get("scout.report", :json)
    end

    def daisy!
      execute("scout.daisy")
      execute("scout.daisy")
    end

    def boot
      execute("scout.boot")
    end

    def temperature
      get("temperature", :integer)
    end

    def random_number
      get("randomnumber", :integer)
    end

    def uptime
      get("uptime", :integer)
    end

    def power
      PowerCommands.new(self)
    end

    def led
      LedCommands.new(self)
    end

    def wifi
      WifiCommands.new(self)
    end

    def mesh
      MeshCommands.new(self)
    end

    def pin
      PinCommands.new(self)
    end

    def events
      EventsCommands.new(self)
    end

    def functions
      FunctionCommands.new(self)
    end
  end



  class CommandCollection
    def initialize(target)
      @target = target
    end

    def get(command, type=nil)
      @target.get(command, type)
    end

    def run(command, type=nil)
      @target.run(command)
    end

    def execute(command)
      @target.execute(command)
    end
  end



  class PowerCommands < CommandCollection
    def charging?
      get("power.ischarging", :boolean)
    end

    def percent
      get("power.percent", :integer)
    end

    def voltage
      get("power.voltage", :integer)
    end

    def enable_vcc
      execute("power.enable_vcc")
    end

    def disable_vcc
      execute("power.disable_vcc")
    end

    def report
      run("power.report", :json)
    end
  end



  class LedCommands < CommandCollection
    def blink(r, g, b, ms=nil, continuous=nil)
      if ms.nil?
        execute("led.blink(#{r}, #{g}, #{b})")
      elsif continuous.nil?
        execute("led.blink(#{r}, #{g}, #{b}, #{ms})")
      else
        continuous = (continuous == 1)
        execute("led.blink(#{r}, #{g}, #{b}, #{ms}, #{continuous})")
      end
    end

    def off; execute("led.off"); end
    def red; execute("led.red"); end
    def green; execute("led.green"); end
    def blue; execute("led.blue"); end
    def cyan; execute("led.cyan"); end
    def purple; execute("led.purple"); end
    def magenta; execute("led.magenta"); end
    def yellow; execute("led.yellow"); end
    def orange; execute("led.orange"); end
    def white; execute("led.white"); end
    def torch; execute("led.torch"); end

    def hex=(value)
      execute(%[led.sethex("#{value}")])
    end

    def rgb=(r, g, b)
      execute(%[led.setrgb(#{r}, #{g}, #{b})])
    end

    def torch=(r, g, b)
      execute(%[led.savetorch(#{r}, #{g}, #{b})])
    end

    def report
      run("led.report", :json)
    end
  end



  class WifiCommands < CommandCollection
    def report
      run("wifi.report", :json)
    end

    def status
      get('wifi.status')
    end

    def list
      get('wifi.list')
    end

    def config(name, password)
      execute(%[wifi.config("#{name}", "#{password}")])
    end

    def reassociate
      execute("wifi.reassociate")
    end

    def connect(name, password)
      config(name, password)
      reassociate
      report
    end

    def command(cmd)
      get(%[wifi.command("#{cmd}")])
    end
  end


  class MeshCommands < CommandCollection
    def config(scout_id, troop_id, channel=20)
      get(%[mesh.config(#{scout_id}, #{troop_id}, #{channel})])
    end

    def power=(level)
      execute("mesh.setpower(#{level})")
    end

    def datarate=(rate)
      execute("mesh.datarate(#{rate})")
    end

    def key=(k)
      execute(%[mesh.setkey("#{k}")])
    end

    def key
      get("mesh.getkey")
    end

    def reset_key
      execute("mesh.resetkey")
    end

    def join_group(group_id)
      execute("mesh.joingroup(#{group_id})")
    end

    def leave_group(group_id)
      execute("mesh.leavegroup(#{group_id})")
    end

    def in_group?(group_id)
      execute("mesh.ingroup(#{group_id})")
    end

    def send_message(scout_id, msg)
      execute(%[mesh.send(#{scout_id}, "#{msg}")])
    end

    def report
      run("mesh.report", :json)
    end

    def routing
      get("mesh.routing")
    end

    def announce(group_id, msg)
      execute(%[mesh.announce(#{group_id}, "#{msg}")])
    end

    def signal
      get('mesh.signal', :integer)
    end
  end

  class PinCommands < CommandCollection
    INPUT         = "INPUT"
    OUTPUT        = "OUTPUT"
    INPUT_PULLUP  = "INPUT_PULLUP"
    DISABLED      = "DISABLED"
    HIGH          = "HIGH"
    LOW           = "LOW"

    def make_input(pin, pullup=INPUT_PULLUP)
      execute(%[pin.makeinput("#{pin}", #{pullup})])
    end

    def make_output(pin)
      execute(%[pin.makeoutput("#{pin}")])
    end

    def disable(pin)
      execute(%[pin.disable("#{pin}")])
    end

    def set_mode(pin, mode)
      execute(%[pin.setmode("#{pin}", #{mode})])
    end

    def read(pin)
      get(%[pin.read("#{pin}")], :integer)
    end

    def write(pin, value)
      execute(%[pin.write("#{pin}", value)], :integer)
    end

    def report_digital
      get('pin.report.digital', :json)
    end

    def report_analog
      get('pin.report.analog', :json)
    end
  end

  class EventsCommands < CommandCollection
    def start
      execute("events.start")
    end

    def stop
      execute("events.stop")
    end

    def set_cycle(digital_ms=50, analogue_ms=60_000, peripheral_ms=60_000)
      execute("events.setcycle(#{digital_ms}, #{analogue_ms}, #{peripheral_ms})")
    end
  end

  class FunctionCommands < CommandCollection
    def list
      ls = run('ls')
      ls.split(/\r?\n/).reduce({}) do |hsh, fn|
        matches = fn.match(/function ([a-z0-9]+) \{/)
        hsh[matches[1]] = fn
        hsh
      end
    end

    def remove(fn)
      execute("rm #{fn}")
    end

    def remove_all
      execute("rm *")
    end

    def repeat(fn, delay)
      execute("run #{fn}, #{delay}")
    end

    def stop(pid)
      pid = pid_for(pid) unless pid.is_a?(Integer)
      execute("stop #{pid}") if pid
    end

    def add(name, body=nil)
      body = name if body.nil?
      body = "function #{name} { #{body} }" unless body =~ /^function /
      execute(body)
    end

    def startup(body)
      add(:startup, body)
    end

    def pid_for(fn)
      process = running.find {|p| p[:function].to_s == fn.to_s }
      return process[:pid] if process
      nil
    end

    def running
      ps = run("ps")
      ps.split(/\r?\n/).map do |line|
        pid, fn = *line.split(": ")
        {pid: pid.to_i, function: fn}
      end
    end
  end
end