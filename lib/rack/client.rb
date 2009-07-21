unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'forwardable'

module Rack
  class Client
    autoload :HTTP, 'rack/client/http'
    autoload :Auth, 'rack/client/auth'
    autoload :FollowRedirects, 'rack/client/follow_redirects'

    VERSION = "0.1.0"

    def self.call(env)
      Rack::Client::HTTP.call(env)
    end
  end
end
