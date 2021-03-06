# +YTLabsApi::Client+ - entry class to the API client.
#
# Proposed usage:
# => client = YTLabsApi::Client.new("your_token", :json)
# => client.get_properties(params_hash)

require_relative 'availability'
require_relative 'booking'
require_relative 'property'
require_relative 'supplementary_information'
require_relative 'cancellation'
require_relative 'room_type'


module YTLabsApi
  class Client
    include HTTParty

    include YTLabsApi::Availability
    include YTLabsApi::Booking
    include YTLabsApi::Cancellation
    include YTLabsApi::Property
    include YTLabsApi::RoomType
    include YTLabsApi::SupplementaryInformation

    END_POINTS = YAML::load(File.open(File.join('lib', 'ytlabs_api', 'end_points.yml')))
    URL = "https://api.ytlabs.co.kr/stage/v1"
    VALID_CONTENT_TYPES = [:json, :xml].freeze

    format :json
    default_timeout 1 #Hard timeout after 1 second.

    attr_reader :token, :content_type, :base_url, :errors

    def initialize(token, content_type=nil)
      @token = token
      @content_type = "application/#{content_type.to_s}" || "application/json"
      @base_url = URL
      @errors = []

      raise InvalidAccessToken unless valid_token?(token)
      raise InvalidContentType unless valid_content_type?(content_type)
    end


    # HTTParty will raise Net::OpenTimeout if it can't connect to the server.
    # It will raise Net::ReadTimeout if reading the response from the server times out.
    # Handle these exceptions to return a empty hash, and set the timeout to 1 second.
    # Wrap any calls made using HTTParty in a handle_timeouts block

    #     handle_timeouts do
    #       your HTTParty call.
    #     end

    # TODO
    # def handle_timeouts
    #   begin
    #     yield
    #   rescue Net::OpenTimeout, Net::ReadTimeout
    #     {}
    #   end
    # end

    # Since the only public methods this client supports are calls to the specified endpoints,
    # which are implemented - we will raise a more specific error here.
    def method_missing(method, *args, &block)
      raise EndPointNotSupported
    end

    private

    ## Transforms {:a => 2, :b => 2} to "a=2&b=2"
    def transform_params!(params)
      URI.encode_www_form(params) if params
    end


    ## Accepts underscored variables/params & converts them to camelCase as required by the YTLabs API.
    ## The intention is to 'Rubify' the wrapper allowing underscore_style_variable_naming.
    ## Example:
    ## camelize_params_keys!({:room_code=>"123", :search_start_date=>"456"})
    ## => {"roomCode"=>"123", "searchStartDate"=>"456"}
    def camelize_params_keys!(params_hash)
      return unless params_hash

      params_hash.keys.each do |key|
        value = params_hash.delete(key)
        new_key = key.to_s.camelize(:lower)
        params_hash[new_key] = value
      end
      params_hash
    end

    ## Builds endpoint URL dynamically.
    def build_url(action, identifier=nil)
      end_point = END_POINTS[action]

      if identifier
        url = "#{base_url}/#{end_point}/#{identifier}"
      else
        url = "#{base_url}/#{end_point}"
      end
      url
    end

    # The responses from the API are somewhat misleading. Calls that one might expect to 404 seem to return 403 Forbidden
    # with "message"=>"Authorization header requires 'Credential' parameter. Consider how to provide more helpful messages.
    def prepare_response(response)
      if response.parsed_response["status"] == (200..206)
        parse_successful_response(response)
      else
        # Temporary
        JSON.parse(response.body)
      end
    end

    def parse_successful_response(response)
      JSON.parse(response.body)
    end

    def valid_token?(token)
      token.size == 36
    end

    def valid_content_type?(content_type)
      VALID_CONTENT_TYPES.include?(content_type)
    end
  end
end