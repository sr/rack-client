require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with a FollowRedirects middleware" do
  it "follows redirects" do
    app = Rack::Builder.new {
      use Rack::Client::FollowRedirects
      run Rack::Client
    }

    client = Rack::MockRequest.new(app)

    response = client.get("http://localhost:9292/redirect")
    response.status.should == 200
    response.body.should == "after redirect"
  end
end
