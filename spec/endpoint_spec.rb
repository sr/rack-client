require File.dirname(__FILE__) + '/spec_helper'

require 'sinatra/base'

class MyApp < Sinatra::Base
  get "/awesome" do
    "test"
  end
end

describe Rack::Client, "with an Rack app endpoint" do
  it "returns the body" do
    client = Rack::Client.new do
      run Rack::URLMap.new("http://example.org/" => MyApp)
    end
    response = client.get("http://example.org/awesome")
    response.status.should == 200
    response.body.should == "test"
  end

  describe "with a custom domain" do
    it "returns the body" do
      client = Rack::Client.new do
        run Rack::URLMap.new("http://google.com/" => MyApp)
      end
      response = client.get("http://google.com/awesome")
      response.status.should == 200
      response.body.should == "test"
    end

    it "only functions for that domain" do
      client = Rack::Client.new do
        run Rack::URLMap.new("http://google.com/" => MyApp)
      end
      response = client.get("http://example.org/awesome")
      response.status.should == 404
    end
  end
end
