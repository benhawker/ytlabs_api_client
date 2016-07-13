require "roomallo_api"
require "webmock/rspec"

# Disable all net connections except localhost
WebMock.disable_net_connect!(:allow_localhost => true)