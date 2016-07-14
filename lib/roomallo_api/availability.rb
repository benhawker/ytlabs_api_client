module RoomalloApi
  module Availability

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

      params.merge!(:searchEndDate  => "#{end_date}") if end_date

      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

  end
end