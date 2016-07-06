## Intial propose usage ++ client = RoomalloAPI::Client.setup("Your token").

module RoomalloAPI
  class Client

    END_POINTS = YAML::load(File.open(File.join('lib', 'roomallo_api', 'end_points.yml')))
    URL = "https://api.ytlabs.co.kr/stage/v1"

    attr_reader :base_url, :token

    def initialize(token)
      raise "Please pass a valid access token" unless valid_token?(token)
      @token = token
      @base_url = URL
    end

    #Public method to build endpoint URL.
    def attribute_url(attribute)
      end_point = END_POINTS[attribute]
      raise(EndpointNotSupported, end_point) unless end_point

      url = "#{base_url}/#{end_point}"
    end

    private

    def auth_get(url, attributes = {})
      auth_request(url, attributes)
    end

    def auth_request(url, attributes)
      raw_response = token.send(method, url, params: attrs)
      prepare_response(raw_response)
    end

    def valid_token?(token)
      token.size == 32
    end
  end
end
