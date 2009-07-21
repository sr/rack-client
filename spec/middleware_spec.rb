require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Client, "with a standard piece of Rack middleware" do
  it "successfully uses that middleware" do
    app = Rack::Builder.new {
      use Rack::ETag
      run Rack::Client
    }

    client = Rack::MockRequest.new(app)

    response = client.get("http://localhost:9292/no-etag")
    response.status.should == 200
    response.headers["ETag"].should_not be_empty
  end
end
