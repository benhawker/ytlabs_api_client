module RoomalloApi
  module RoomType

    # GET /roomtypes/
    # Obtain a list of all room types.
    # When parameter 'updatedAt' is specified in request, only updated information is returned.

    def get_room_types(params=nil)

    end

    # GET /properties/{propertyID}/roomtypes/
    # Using a specific propertyID, get all roomtypes' information of the property.

    def get_property_room_types(params=nil)

    end

  end
end