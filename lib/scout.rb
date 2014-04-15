require_relative "./commands"

module Pinoccio
  class Scout
    include Commands

    attr_reader :troop, :id

    def initialize(client, troop, props)
      @client = client
      @troop = troop
      @id = props.id
    end

    def get(command, type=nil)
      run("print #{command}", type)
    end

    def run(command, type=nil)
      result = execute(command).reply.strip
      case type
        when :boolean
          result == "1"
        when :integer
          result.to_i
        when :json
          JSON.parse(result)
        else
          result
      end
    end

    def execute(command)
      @client.get("#{@troop.id}/#{@id}/command", command: command)
    end
  end
end