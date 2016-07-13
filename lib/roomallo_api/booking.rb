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

    # POST /reservation/cancel/

    # _________________________________________________________________________________________ #

    # GET /reservation/information
    # https://api.ytlabs.co.kr/stage/v1/reservation/information?searchStartDate=2016-07-01&searchEndDate=2016-07-10&reservationNo=

  end
end