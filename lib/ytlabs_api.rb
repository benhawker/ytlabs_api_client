require 'json'
require 'yaml'
require 'httparty'
require 'active_support/inflector'

require_relative 'ytlabs_api/client'

## Exceptions
module YTLabsApi

  #To be implemented in the Client.
  class NetworkError < StandardError
    def initialize(status, body)
      super("Error. HTTP status: #{status}. Response body: #{body}")
    end
  end

  class InvalidAccessToken < StandardError
    def initialize
      super("Your access token is not valid. It must be 36 characters long.")
    end
  end

  class InvalidContentType < StandardError
    def initialize
      super("Your content type is invalid. 'json' or 'xml' are the 2 valid options")
    end
  end

  class EndPointNotSupported < StandardError
    def initialize
      super("This endpoint is not supported: Try one of these: #{Client::END_POINTS.keys}")
    end
  end
end
