require 'active_model'

require_relative 'roomallo_api/config'
require_relative 'roomallo_api/client'

module RoomalloAPI
  class Error < RuntimeError ; end
  class EndPointNotImplemented < Error ; end
end