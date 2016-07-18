YTLabs API Client
===================

A Ruby wrapper packaged as a Gem enabling Ruby calls to the Yello Travel Labs API which provides endpoints to search & book their inventory of Korea based rental properties. Visit Yello Travel Labs at [http://www.ytlabs.co.kr/](http://www.ytlabs.co.kr/). You will need an access token.

The YTLabs API uses camelCase params, however as this is a Ruby wrapper I have followed the Ruby convention of using underscore_case parameter naming, with the exception of `client.post_reservation_confirmation`. The belows README (and also the comments above the definition of each method) documents all required and optional parameter formats.

A work in progress as of July 2016, hence currently calling staging url.

### Requirements:

httparty [github.com/jnunemaker/httparty](http://www.github.com/jnunemaker/httparty)

===================

### Usage:

```
client = YTLabsApi::Client.new("your_token", :json)
```

===================

### Endpoints covered:

#### GET Requests

#### get_properties:     "GET /properties/"
```
Use this resource to get a response a list of properties in the YTLabs API.

- Required => updated_at                    Date at which data starts being returned. (YYYY-MM-
- Optional => i18n        default: "ko-KR"  Return text in other lanaguages(ko-KR, en-US, zh-CN,
- Optional => offset      default: 0        Data offset (default 0)
- Optional => limit       default: 30       Amount of requested properties (default 30)
- Optional => active      default: 1        To filter by only active properties. 0 returns all. 1 returns Active o

When parameter 'limit=0&updatedAt=1970-01-01' is specified in request, all of the properties' information is
returned. It is recommended only for the first ever call made to retrieve all information.

Usage: get_property(params)
Example usage: client.get_properties(:updated_at => "1970-01-01", :limit => 3)
```
===================

#### get_property:       "GET /properties/{propertyID}/"
```
Use this resource with a property_identifier (e.g. "w_w0307279") to get the property's information.

- Required => property_identifier            The unique property identifier/hash (e.g. w_w0307279)
- Optional => i18n        default: "ko-KR"   Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

Usage: get_property(property_identifier, params=nil)
Example usage: client.get_property("w_w0307279", :i18n => "en-US")
```
===================

#### get_availability:     "GET /available/{propertyID}"
```
Use this resource with a property_identifier (e.g. "w_w0307279") & a stay start_date to obtain rates & availability.

Required => property_identifier               The unique property identifier/hash (e.g. w_w0307279)
Required => start_date                                  YYYY-MM-DD (ex: 2016-02-01). Stay start date.
Optional => end_date      default: (start_date + 1 day) YYYY-MM-DD (ex: 2016-02-05). Stay end date. If empty, defaults to start_date + 1 day.

Usage: get_availability(property_identifier, start_date, end_date=nil)
Example usage: client.get_availability("w_w0307279_R01", "2016-07-01", "2016-07-10")
```
===================

#### get_provinces:        "GET /provincecode/"
```
Returns a list with code or name of province.
- Optional => i18n        default: "ko-KR"    Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

Example usage: client.get_provinces
```
===================

#### get_cities:       "GET /citycode/"
```
Returns a list with code or name of cities.
- Optional => i18n        default: "ko-KR"    Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

Example usage: client.get_cities
```
===================


#### get_extra_service_codes: "GET /extraservicecode/"
```
Returns a list mapping the codes and names of extra services.
- Optional => i18n        default: "ko-KR"    Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

Example usage: client.get_extra_service_codes
```
===================

#### get_theme_codes:      "GET /themecode/"
```
Returns a list mapping the code and name of themes.
- Optional => i18n        default: "ko-KR"    Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-JP)

Example usage: client.get_theme_codes
```
===================

#### ERRORS. get_reservations:     "GET /reservation/information"
```
1. Use this resource with a set of dates to retrieve a collection of reservations between the given dates
2. Use this resource with a reservation identifier(hash) + the start date to retrieve a collection of one reservation.

- Required => start_date              YYYY-MM-DD (ex: 2016-02-01). Search by start date.
- Required => end_date                YYYY-MM-DD (ex: 2016-02-05). Search by end date.
- Optional => reservation_identifier  The unique property identifier/hash (e.g. w_w03072)

Example usage: client.get_reservations("2016-07-01", "2016-07-10", "w_w0307279_R01")
```
===================

#### get_room_types:       "GET /roomtypes/"
```
Use this resource to obtain a list of all room types.
- Required => updated_at                     Date at which data starts being returned. (YYYY-MM-
- Optional => i18n        default: "ko-KR"   Return text in other lanaguages(ko-KR, en-US, zh-CN, ja-
- Optional => offset      default: 0         Data offset (default 0)
- Optional => limit       default: 30        Amount of requested room type (default 30)
- Optional => active      default: 1         To filter by only active room type. 0 returns all. 1 returns Active o

Example usage: client.get_room_types(:updated_at => "1970-01-01", :limit => 1)
```
===================

#### get_property_room_types: "GET /properties/{propertyID}/roomtypes/"
```
Using a specific propertyID, get all roomtypes' information of the property.

- Required => property_identifier           Date at which data starts being returned. (YYYY-MM-
- Optional => i18n        default: "ko-KR"  Return text in other lanaguages(ko-KR, en-US, zh-CN, ja

Example usage: client.get_property_room_types("w_w0307279", :i81n => "en-US")
```
===================

#### get_cancellation_charge: "GET /reservation/cancelcharge/"
```
Using a reservation number get the cancellation fee payable. If a reservation is cancelled within 7 days of the check in day, a cancellation fee will be charged.

- Required => reservation_number      Unique reservation number

Example usage: client.get_cancellation_charge("w_WP20160705145532ECD5")
```

#### POST Requests

#### TO BE TESTED. post_reservation_request(property_identifier, start_date, end_date):     "POST /reservation/holding/"
```
Before making a reservation, the room must be held - to prevent double booking.

Format expected (JSON content type):
  {
    "roomCode" : "w_w0814002_R01",
    "checkInDate" : "2016-09-15",
    "checkOutDate" : "2016-09-16"
  }

Example usage: client.post_reservation_request("w_w0307279", "2016-09-15", "2016-09-18")
```
===================


#### TO BE TESTED. post_reservation_confirmation: "POST /reservation/confirm"
```
---
```
===================

#### TO BE TESTED. post_cancel_reservation:     "POST /reservation/cancel"
```
---
```
