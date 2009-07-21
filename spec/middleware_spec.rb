require File.dirname(__FILE__) + '/spec_helper'
require "rack/cache"

describe Rack::Client, "with a standard piece of Rack middleware" do
  it "successfully uses that middleware" do
    client = Rack::Client.new { use Rack::ETag }

    response = client.get("http://localhost:9292/no-etag")
    response.status.should == 200
    response.headers["ETag"].should_not be_empty
  end

  it "works with Rack::Cache as a client-side cache OMGWTFBBQPONY" do
    app = Rack::Builder.new {
      use Rack::Cache,
        :verbose     => true,
        :metastore   => "heap:/",
        :entitystore => "heap:/"
      run Rack::Client
    }

    client = Rack::MockRequest.new(app)

    response = client.get("http://localhost:9292/ping")
    response["X-Rack-Cache"].should == "miss, store"
    response.body.should == "pong"

    response = client.get("http://localhost:9292/ping")
    response["X-Rack-Cache"].should == "stale, valid, store"
    response.body.should == "pong"
  end
end
