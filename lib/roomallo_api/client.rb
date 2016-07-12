## Intial proposed usage ++ client = RoomalloApi::Client.new("Your token")
## client.get_properties(your_params)

module RoomalloApi
  class Client
    include HTTParty

    END_POINTS = YAML::load(File.open(File.join('lib', 'roomallo_api', 'end_points.yml')))
    URL = "https://api.ytlabs.co.kr/stage/v1"
    DEFAULT_LOCALE = "en-US"
    VALID_CONTENT_TYPES = ["json", "xml"]

    format :json

    attr_reader :token, :content_type, :base_url, :errors

    def initialize(token, content_type=nil)
      raise InvalidAccessToken unless valid_token?(token)
      raise InvalidContentType unless valid_content_type?(content_type)
      @token = token
      @content_type = "application/#{content_type}" || "application/json"
      @base_url = URL
      @errors = []
    end

    # GET /properties/
    # Use this resource to get a response a list of properties in the Roomallo API.
    #
    # Parameters:
    #
    #     Required => updated_at                          Date at which data starts being returned. (YYYY-MM-DD).
    #
    #     Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)
    #     Optional => offset      default: 0              Data offset (default 0)
    #     Optional => limit       default: 30             Amount of requested properties (default 30)
    #     Optional => active      default: 1              To filter by only active properties. 0 returns all. 1 returns Active only.
    #
    #     When parameter 'limit=0&updatedAt=1970-01-01' is specified in request, all of the properties' information is
    #     returned. It is recommended only for the first time
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/properties?i18n=en-US&offset=0&limit=30&active=1&updatedAt=2016-05-24
    #
    # Example usage: client.get_properties( {:updated_at => "1970-01-01", limit => 3} )

    def get_properties(params=nil)
      camelize_params_keys!(params)

      HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end

    # GET /properties/{propertyID}/
    # Use this resource with a property_identifier (e.g. "w_w0307279") to get the property's information.
    #
    # Parameters:
    #
    #     Required => property_identifier                  The unique property identifier/hash (e.g. w_w0307279)
    #
    #     Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/properties/w_w0307279?i18n=en-US
    #
    # Example usage: client.get_property("w_w0307279", {:i18n => "en-US"} )

    def get_property(property_identifier, params=nil)
      camelize_params_keys!(params)

      HTTParty.get(
        "#{build_url(__method__.to_s, property_identifier)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end




    # GET /available/
    # Use this resource with a property_identifier (e.g. "w_w0307279") & a stay start_date to obtain rates & availability.
    #
    # Parameters:
    #
    #     Required => property_identifier                         The unique property identifier/hash (e.g. w_w0307279)
    #     Required => start_date                                  YYYY-MM-DD (ex: 2016-02-01). Stay start date.
    #
    #     Optional => end_date      default: start_date + 1 day   YYYY-MM-DD (ex: 2016-02-05). Stay end date. If empty, defaults to start_date + 1 day.
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/available?roomCode=w_w0307279_R01&searchStartDate=2016-07-01&searchEndDate=2016-07-10
    #
    # Example usage: client.get_availability("w_w0307279_R01", "2016-12-01", "2016-12-10")

    def get_availability(property_identifier, start_date, end_date=nil)
      params = {
                 :roomCode => "#{property_identifier}",
                 :searchStartDate => "#{start_date}"
               }

      # params = {
      #            :roomCode => "123",
      #            :searchStartDate => "456"
      #          }

      params.merge!(:searchEndDate  => "#{end_date}") if end_date

      HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end




    # GET /provincecode/
    # Returns a list with code or name of province.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_provinces
      HTTParty.get(
        "#{build_url(__method__.to_s)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end



    # GET /citycode/
    # Returns a list with code or name of cities.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_cities
      HTTParty.get(
        "#{build_url(__method__.to_s)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end




    # GET /extraservicecode/
    # Returns a list mapping the codes and names of extra services.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_extra_service_codes
      HTTParty.get(
        "#{build_url(__method__.to_s)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end




    # GET /themecode/
    # Returns a list mapping the code and name of themes.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_theme_codes
      HTTParty.get(
        "#{build_url(__method__.to_s)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end



    # _________________________________________________________________________________________ #

    # POST /reservation/holding/
    # Before making a reservation, the room must be held - to prevent double booking.
    # Other customers cannot make a reservation until the holding status has ended.
    # If 'pending' is returned in the response, the user can request Reservation Confirm.

    # Format expected (JSON content type):
    #
    # {
    #   "roomCode" : "w_w0814002_R01",
    #   "checkInDate" : "2016-09-15",
    #   "checkOutDate" : "2016-09-16"
    # }

    def post_reservation_request(property_identifier, start_date, end_date)
      request_body = {
                 :roomCode     => "#{property_identifier}",
                 :checkInDate  => "#{start_date}",
                 :checkOutDate => "#{end_date}"
               }.to_json

     # params = {
     #   :roomCode     => "bob",
     #   :checkInDate  => "joe",
     #   :checkOutDate => "steve"
     # }.to_json

      HTTParty.post(
        "#{build_url(__method__.to_s)}",
        body:    request_body,
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

    end

    # POST /reservation/confirm/
    # The user must have a valid reservation number that will have been returned by making a successful 'reservation request'.

    # Format expected (JSON content type):
    #
    # {
    #  *** Required ***
    #   "reservationNo" : "w_WP000000000000000",
    #   "roomtypeCode" : "w_w0814002_R01",
    #   "checkInDate" : "2016-09-15",
    #   "checkOutDate" : "2016-09-16",
    #   "guestName" : "Lucy",
    #   "guestCount" : 3,
    #   "adultCount" : 2,
    #   "childrenCount" : 1,
    #   "paidPrice" : 2000.0,
    #   "sellingPrice" : 2000.0,
    #   "commissionPrice" : 200.0,
    #   "currency" : "KRW",
    #
    #  *** Optional ***
    #   "guestPhone" : "010-0000-0000",
    #   "guestEmail" : "aaa@mail.com",
    #   "guestNationality" : "Korea"
    # }

    def post_reservation_confirmation(request_body={})
      HTTParty.post(
        "#{build_url(__method__.to_s)}",
        body:    request_body.to_json,
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end

    # POST /reservation/cancel/

    # GET /reservation/information
    # https://api.ytlabs.co.kr/stage/v1/reservation/information?searchStartDate=2016-07-01&searchEndDate=2016-07-10&reservationNo=

    # _________________________________________________________________________________________ #

    private

    ## Transforms {:a => 2, :b => 2} to "a=2&b=2"
    def transform_params!(params)
      URI.encode_www_form(params) if params
    end

    ## Accepts underscored variables/params & converts them to camelCase as required by the Roomallo API.
    ## The intention is to 'Rubify' the wrapper allowing users to use it in a Ruby friendly way.
    # Example:
    # camelize_params_keys!({:room_code=>"123", :search_start_date=>"456"})
    # => {"roomCode"=>"123", "searchStartDate"=>"456"}
    def camelize_params_keys!(params_hash)
      return unless params_hash

      params_hash.keys.each do |key|
        value = params_hash.delete(key)
        new_key = key.to_s.camelize(:lower)
        params_hash[new_key] = value
      end
      params_hash
    end

    #Private method to build endpoint URL.
    def build_url(action, identifier=nil)
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

    def valid_content_type?(content_type)
      VALID_CONTENT_TYPES.include?(content_type)
    end
  end
end