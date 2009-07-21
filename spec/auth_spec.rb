require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with an Auth::Basic middleware" do
  it "succeeds with authorization" do
    app = Rack::Builder.new {
      use Rack::Client::Auth::Basic, "username", "password"
      run Rack::Client
    }

    client = Rack::MockRequest.new(app)

    response = client.get("http://localhost:9292/auth/ping")
    response.status.should == 200
    response.headers["Content-Type"].should == "text/html"
    response.body.should == "pong"
  end

  it "fails with authorization" do
    app = Rack::Builder.new {
      use Rack::Client::Auth::Basic, "username", "fail"
      run Rack::Client
    }

    client = Rack::MockRequest.new(app)

    response = client.get("http://localhost:9292/auth/ping")
    response.status.should == 401
    response.body.should == ""
  end
end
