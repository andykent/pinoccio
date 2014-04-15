require_relative "./commands"

module Pinoccio
  class Troop
    include Commands

    attr_reader :account, :id, :online, :name

    def initialize(client, props)
      @client = client
      @account = props.account
      @id = props.id
      @online = props.online
      @name = props.name
    end

    def scouts
      ScoutCollection.new(@client, self)
    end

    def run(command, type=nil)
      collect_across_all { |scout| scout.run(command, type) }
    end

    def get(command, type=nil)
      collect_across_all { |scout| scout.get(command, type) }
    end

    def execute(command)
      collect_across_all { |scout| scout.execute(command) }
    end

    private
    def collect_across_all(&blk)
      scouts.all.reduce({}) do |hsh, scout|
        hsh[scout.id] = yield(scout)
        hsh
      end
    end
  end
end