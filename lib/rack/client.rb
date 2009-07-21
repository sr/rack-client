unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__) + "/.."))
  $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/.."))
end

require 'rack'
require 'forwardable'

module Rack
  module Client
    autoload :HTTP, 'rack/client/http'
    autoload :Auth, 'rack/client/auth'
    autoload :FollowRedirects, 'rack/client/follow_redirects'

    VERSION = "0.1.0"

    class << self
      extend Forwardable
      def_delegators :new, :head, :get, :put, :post, :delete

      attr_accessor :client
    end

    self.client =  Proc.new { |app|
      Rack::Test::Session.new(Rack::MockSession.new(app))
    }

    def self.new(client=self.client, &block)
      app = Rack::Builder.new(&block)
      app.run(self)

      client.call(app)
    end

    def self.call(env)
      Rack::Client::HTTP.call(env)
    end
  end
end
