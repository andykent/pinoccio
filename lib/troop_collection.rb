module Pinoccio
  class TroopCollection
    def initialize(client)
      @client = client
    end

    def first
      all.first
    end

    def all
      result = @client.get("troops")
      result = [result] unless result.is_a?(Array)
      result.map {|t| Troop.new(@client, t) }
    end

    def get(troop_id)
      result = @client.get("troops/#{troop_id}")
      Troop.new(@client, result)
    end
  end
end