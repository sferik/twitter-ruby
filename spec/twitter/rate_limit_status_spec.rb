require 'helper'

describe Twitter::RateLimitStatus do

  describe "#reset_time" do
    it "should return a Time when reset_time is set" do
      user = Twitter::RateLimitStatus.new('reset_time' => "Mon Jul 16 12:59:01 +0000 2007")
      user.reset_time.should be_a Time
    end
    it "should return nil when reset_time is not set" do
      user = Twitter::RateLimitStatus.new
      user.reset_time.should be_nil
    end
  end

end
