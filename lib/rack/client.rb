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

    def self.new(&block)
      Builder.new(&block).to_app
    end

    def self.call(env)
      Rack::Client::HTTP.call(env)
    end

    class Builder < Rack::Builder
      def initialize(&block)
        @client = Proc.new { |app| Rack::MockRequest.new(app) }
        super
      end

      def client(&block)
        @client = block
      end

      def run(*args, &block)
        @ran = true
        super(*args, &block)
      end

      def to_app(*args, &block)
        run Rack::Client::HTTP unless @ran
        @client.call(super(*args, &block))
      end
    end
  end
end
