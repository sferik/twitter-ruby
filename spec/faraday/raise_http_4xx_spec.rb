require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response::RaiseHttp4xx do
  before do
    @client = Twitter::Client.new
  end

  context "when response status is 400" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 400)
    end

    it "should raise Twitter::BadRequest" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::BadRequest
    end

  end

  context "when response status is 401" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 401)
    end

    it "should raise Twitter::Unauthorized" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::Unauthorized
    end

  end

  context "when response status is 403" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 403)
    end

    it "should raise Twitter::Forbidden" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::Forbidden
    end

  end

  context "when response status is 404" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 404)
    end

    it "should raise Twitter::NotFound" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::NotFound
    end

  end

  context "when response status is 406" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 406)
    end

    it "should raise Twitter::NotAcceptable" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::NotAcceptable
    end

  end

  context "when response status is 420" do

    before do
      stub_get("statuses/user_timeline.json?screen_name=sferik").
        to_return(:status => 420, :headers => {'retry-after' => 420})
    end

    it "should raise Twitter::EnhanceYourCalm" do
      lambda do
        @client.user_timeline('sferik')
      end.should raise_error Twitter::EnhanceYourCalm
    end

    it "should capture wait time" do
      begin
        @client.user_timeline('sferik')
      rescue Twitter::EnhanceYourCalm => error
        error.retry_after.should == 420
      end
    end
  end
end
