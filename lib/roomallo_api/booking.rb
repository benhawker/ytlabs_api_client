module RoomalloApi
  module Booking

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

      HTTParty.post(
        "#{build_url(__method__.to_s)}",
        body:    request_body,
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )
    end

    # _________________________________________________________________________________________ #

    # POST /reservation/confirm/
    # The user must have a valid reservation number that will have been returned by making a successful 'reservation request'.
    #
    # Note that this method accepts a body with keys specified in camelcase.

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

    # _________________________________________________________________________________________ #

    # GET /reservation/information

    # Use this resource with a set of dates to retrieve a collection of reservations between the given dates
    # OR
    # Use this resource with a reservation identifier(hash) + the start date to retrieve a collection of one reservation.
    #
    # Parameters:
    #
    #     Required => start_date                                         YYYY-MM-DD (ex: 2016-02-01). Search by start date.
    #     Required => end_date                                           YYYY-MM-DD (ex: 2016-02-05). Search by end date.
    #     Optional => reservation_identifier                             The unique property identifier/hash (e.g. w_w0307279)
    #
    # Example Request: https://api.ytlabs.co.kr/stage/v1/reservation/information?searchStartDate=2016-07-01&searchEndDate=2016-07-10&reservationNo=
    #
    # Example usage: client.get_reservations("w_w0307279_R01", "2016-12-01", "2016-12-10")

    def get_reservations(start_date, end_date, reservation_identifier=nil)
      params = {
                 :searchStartDate => "#{start_date}",
                 :searchEndDate => "#{end_date}"
               }

      params.merge!( :roomCode => "#{reservation_identifier}" ) if reservation_identifier

      response = HTTParty.get(
        "#{build_url(__method__.to_s)}?#{transform_params!(params)}",
        headers: { "Authorization" => token.to_s, "Content-Type" => "#{content_type}" }
      )

      prepare_response(response)
    end

  end
end