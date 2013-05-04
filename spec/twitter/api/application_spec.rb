require 'helper'

describe Twitter::API::Application do

  before do
    @client = Twitter::Client.new
  end

  describe "#rate_limit_status" do
    before do
      stub_get("/1.1/application/rate_limit_status.json").to_return(:body => fixture("rate_limit_status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.rate_limit_status
      expect(a_get("/1.1/application/rate_limit_status.json")).to have_been_made
    end
    it "returns the application rate limit status" do
      rate_limist_status  = @client.rate_limit_status
      expect(rate_limist_status.keys).to include(:rate_limit_context)
    end
  end

end
