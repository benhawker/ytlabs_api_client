module YTLabsApi
  module RoomType

    # GET /roomtypes/
    # Obtain a list of all room types.

    # Parameters:
    #
    #     Required => updated_at                          Date at which data starts being returned. (YYYY-MM-DD).
    #
    #     Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)
    #     Optional => offset      default: 0              Data offset (default 0)
    #     Optional => limit       default: 30             Amount of requested room type (default 30)
    #     Optional => active      default: 1              To filter by only active room type. 0 returns all. 1 returns Active only.
    #
    #     When parameter 'updatedAt' is specified in request, only updated information is returned.
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/roomtypes?i18n=en-US&offset=0&limit=30&active=1&updatedAt=2016-05-24
    #
    # Example usage: client.get_room_types(:updated_at => "1970-01-01", :limit => 1)

    def get_room_types(params=nil)
      camelize_params_keys!(params)

      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end


    # GET /properties/{propertyID}/roomtypes/
    # Using a specific propertyID, get all roomtypes' information of the property.

    # Parameters:
    #
    #     Required => property_identifier                        Date at which data starts being returned. (YYYY-MM-DD).
    #
    #     Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/properties/w_w0307279/roomtypes?i18n=en-US
    #
    # Example usage: client.get_property_room_types("w_w0307279", :i81n => "en-US")

    def get_property_room_types(property_identifier, params=nil)
      camelize_params_keys!(params)

      response = HTTParty.get(
        "#{build_url(__method__.to_s, property_identifier)}/roomtypes?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

  end
end