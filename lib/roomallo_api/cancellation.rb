module RoomalloApi
  module Cancellation

    # POST /reservation/cancel/
    #
    # If a reservation is canceled by the guest, the partner should request /reservation/cancel/
    # If a real reservation is not completed within 10 minutes after ReservationHolding, Partner should also request /reservation/cancel/
    #
    # {
    #   "reservationNo" : "w_WP0000000000000000",
    #   "refundPaidPrice" : 2000.0,
    #   "refundCommissionPrice" : 200.0,
    #   "currency" : "KRW"
    # }

    def post_cancellation_request(reservation_number, paid_price, commission_price, currency)
      request_body = {
                 :reservationNo         => "#{reservation_number}",
                 :refundPaidPrice       => "#{paid_price}",
                 :refundCommissionPrice => "#{commission_price}",
                 :currency              => "#{currency}"
               }.to_json

      HTTParty.post(
        "#{build_url(__method__.to_s)}",
        body:    request_body,
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end

    # GET /reservation/cancelcharge/
    # Using a reservation number get the cancellation fee payable.
    #
    # If a reservation is cancelled within 7 days of the check in day, a cancellation fee will be charged.

    # Parameters:
    #
    #     Required => reseveration_number             Unique reservation number - provided when booking was made.
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/reservation/cancelcharge?reservationNo=w_WP20160705145532ECD5
    #
    # Example usage: client.get_cancellation_charge("w_WP20160705145532ECD5")
    def get_cancellation_charge(reservation_number)
      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?reservationNo=#{reservation_number}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

  end
end