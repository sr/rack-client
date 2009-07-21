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

    class << self
      extend Forwardable
      def_delegators :new, :head, :get, :put, :post, :delete
    end

    extend Forwardable
    def_delegators :client, :head, :get, :put, :post, :delete

    def initialize(&block)
      @app = Rack::Builder.new(&block)
      @app.run(self.class)
      @app.to_app
    end

    private

    def client
      @client ||= Rack::Test::Session.new(Rack::MockSession.new(@app))
    end
  end
end
