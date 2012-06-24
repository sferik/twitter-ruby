require 'helper'

describe Twitter::RateLimitStatus do

  describe "#reset_time" do
    it "returns a Time when reset_time is set" do
      rate_limit_status = Twitter::RateLimitStatus.new(:reset_time => "Mon Jul 16 12:59:01 +0000 2007")
      rate_limit_status.reset_time.should be_a Time
    end
    it "returns nil when reset_time is not set" do
      rate_limit_status = Twitter::RateLimitStatus.new
      rate_limit_status.reset_time.should be_nil
    end
  end

end
