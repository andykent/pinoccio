require "faraday"
require "json"
require "ostruct"

require_relative "./client"
require_relative "./troop_collection"
require_relative "./troop"
require_relative "./scout_collection"
require_relative "./scout"

module Pinoccio
  class Error < StandardError
  end

  class TimeoutError < Error
  end
end