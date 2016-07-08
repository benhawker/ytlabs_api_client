## Intial proposed usage ++ client = RoomalloApi::Client.new("Your token")
## client.get_properties(your_params)

module RoomalloApi
  class Client
    include HTTParty

    END_POINTS = YAML::load(File.open(File.join('lib', 'roomallo_api', 'end_points.yml')))
    URL = "https://api.ytlabs.co.kr/stage/v1"
    DEFAULT_LOCALE = "en-US"

    attr_reader :base_url, :token, :errors

    def initialize(token)
      raise InvalidAccessToken unless valid_token?(token)
      @token = token
      @base_url = URL
      @errors = []
    end

    #Initial testing before removing to a module
    def get_properties(params=nil)
      HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "application/json" }
      )
    end

    def get_property(property_identifier, params=nil)
      HTTParty.get(
        "#{build_url(__method__.to_s, property_identifier)}?i18n=en-US",
        headers: { "Authorization" => token.to_s, "Content-Type" => "application/json" }
      )
    end

    private

    ## Transforms {:a => 2, :b => 2} to "a=2&b=2"
    def transform_params(params)
      URI.encode_www_form(params)
    end

    #Private method to build endpoint URL.
    def build_url(action, identifier = nil)
      end_point = END_POINTS[action]
      # raise(EndpointNotSupported, end_point) unless end_point

      if identifier
        url = "#{base_url}/#{end_point}/#{identifier}"
      else
        url = "#{base_url}/#{end_point}"
      end
      url
    end

    def valid_token?(token)
      token.size == 32
    end
  end
end