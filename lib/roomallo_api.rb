require 'active_model'
require 'json'
require 'yaml'
require 'httparty'

require_relative 'roomallo_api/client'

## Exceptions
module RoomalloApi
  class NetworkError < StandardError
    def initialize(status, body)
      super("Error. HTTP status: #{status}. Response body: #{body}")
    end
  end

  class InvalidAccessToken < StandardError
    def initialize
      super("Your access token is not valid. It must be 32 characters long.")
    end
  end

  class InvalidContentType < StandardError
    def initialize
      super("Your content type is invalid. 'json' or 'xml' are the 2 valid options")
    end
  end

  class EndPointNotSupported < StandardError
    def initialize(end_point)
      super("This endpoint is not supported: #{end_point}")
    end
  end

  class ParameterError < StandardError; end
  class InternalServerError < StandardError; end
  class InvalidResponseError < StandardError; end
end