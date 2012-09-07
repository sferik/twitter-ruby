require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#rate_limit_status" do
    before do
      stub_get("/1.1/application/rate_limit_status.json").
        to_return(:body => fixture("rate_limit_status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.rate_limit_status
      a_get("/1.1/application/rate_limit_status.json").
        should have_been_made
    end
    it "returns the remaining number of API requests available to the requesting user before the API limit is reached" do
      rate_limit_status = @client.rate_limit_status
      rate_limit_status.should be_a Twitter::RateLimitStatus
      rate_limit_status.remaining_hits.should eq 19993
    end
  end

end
