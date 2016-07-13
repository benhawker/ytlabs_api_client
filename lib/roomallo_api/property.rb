module RoomalloApi
  module Property

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
    #response.parsed_response["data"]["items"]

    # _________________________________________________________________________________________ #

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

  end
end