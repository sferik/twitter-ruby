require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response::RaiseHttp5xx do
  before do
    @client = Twitter::Client.new
  end

  context "when response status is 500" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 500)
    end

    it "should raise Twitter::InternalServerError" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::InternalServerError
    end

  end

  context "when response status is 502" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 502)
    end

    it "should raise Twitter::BadGateway" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::BadGateway
    end

  end

  context "when response status is 503" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 503)
    end

    it "should raise Twitter::ServiceUnavailable" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::ServiceUnavailable
    end
  end
end
