require 'active_model'

require_relative 'roomallo_api/client'
require_relative 'roomallo_api/properties'

module RoomalloAPI
  class NetworkError < StandardError
    def initialize(status, body)
      super("Error. HTTP status: #{status}. Response body: #{body}")
    end
  end

  class EndPointNotSupported < StandardError
    def initialize(end_point)
      super("This endpoint is not supported: #{end_point}")
    end
  end

  class ParameterError < StandardError; end

end