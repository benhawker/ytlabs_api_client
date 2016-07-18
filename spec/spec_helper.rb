require "ytlabs_api"
require "webmock/rspec"

# Disable all net connections except localhost.
# Override this in a specific spec with ++WebMock.allow_net_connect!++
WebMock.disable_net_connect!(:allow_localhost => true)