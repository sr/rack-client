unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'rack/test'
require 'forwardable'

module Rack
  class Client < Rack::Builder
    autoload :HTTP, 'rack/client/http'
    autoload :Auth, 'rack/client/auth'
    autoload :FollowRedirects, 'rack/client/follow_redirects'

    VERSION = "0.1.0"
    include Rack::Test::Methods
    HTTP_METHODS = [:head, :get, :put, :post, :delete]
    
    class << self
      extend Forwardable
      def_delegators :new, *HTTP_METHODS
    end

    def run(*args, &block)
      @ran = true
      super(*args, &block)
    end

    def to_app(*args, &block)
      run Rack::Client::HTTP unless @ran
      super(*args, &block)
    end
    alias app to_app
  end
end
