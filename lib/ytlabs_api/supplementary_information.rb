module YTLabsApi
  module SupplementaryInformation

    # GET /provincecode/
    # Returns a list with code or name of province.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_provinces(i18n="ko-KR")
      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?i18n=#{i18n}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

    # _________________________________________________________________________________________ #

    # GET /citycode/
    # Returns a list with code or name of cities.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_cities(i18n="ko-KR")
      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?i18n=#{i18n}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

    # _________________________________________________________________________________________ #

    # GET /extraservicecode/
    # Returns a list mapping the codes and names of extra services.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_extra_service_codes(i18n="ko-KR")
      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?i18n=#{i18n}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

    # _________________________________________________________________________________________ #

    # GET /themecode/
    # Returns a list mapping the code and name of themes.
    # Optional => i18n        default: "ko-KR"        Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

    def get_theme_codes(i18n="ko-KR")
      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?i18n=#{i18n}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

  end
end