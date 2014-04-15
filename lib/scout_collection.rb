module Pinoccio
  class ScoutCollection
    def initialize(client, troop)
      @client = client
      @troop = troop
    end

    def first
      all.first
    end

    def lead
      all.find {|scout| scout.lead? }
    end

    def all
      result = @client.get("#{@troop.id}/scouts")
      result = [result] unless result.is_a?(Array)
      result.map {|s| Scout.new(@client, @troop, s) }
    end

    def get(scout_id)
      result = @client.get("#{@troop.id}/#{scout_id}")
      Scout.new(@client, @troop, result)
    end
  end
end