require 'helper'

describe Twitter::RateLimit do
  after do
    Twitter::RateLimit.instance.reset!
  end

  describe "#limit" do
    it "returns an Integer when X-RateLimit-Limit header is set" do
      rate_limit = Twitter::RateLimit.instance.update('X-RateLimit-Limit' => "150")
      rate_limit.limit.should be_an Integer
      rate_limit.limit.should eq 150
    end
    it "returns nil when X-RateLimit-Limit header is not set" do
      rate_limit = Twitter::RateLimit.instance
      rate_limit.limit.should be_nil
    end
  end

  describe "#class" do
    it "returns a String when X-RateLimit-Class header is set" do
      rate_limit = Twitter::RateLimit.instance.update('X-RateLimit-Class' => "api")
      rate_limit.class.should be_an String
      rate_limit.class.should eq "api"
    end
    it "returns nil when X-RateLimit-Class header is not set" do
      rate_limit = Twitter::RateLimit.instance
      rate_limit.class.should be_nil
    end
  end

  describe "#remaining" do
    it "returns an Integer when X-RateLimit-Remaining header is set" do
      rate_limit = Twitter::RateLimit.instance.update('X-RateLimit-Remaining' => "149")
      rate_limit.remaining.should be_an Integer
      rate_limit.remaining.should eq 149
    end
    it "returns nil when X-RateLimit-Remaining header is not set" do
      rate_limit = Twitter::RateLimit.instance
      rate_limit.remaining.should be_nil
    end
  end

  describe "#reset_at" do
    it "returns a Time when X-RateLimit-Reset header is set" do
      rate_limit = Twitter::RateLimit.instance.update('X-RateLimit-Reset' => "1339019097")
      rate_limit.reset_at.should be_a Time
      rate_limit.reset_at.should eq Time.at(1339019097)
    end
    it "returns nil when X-RateLimit-Reset header is not set" do
      rate_limit = Twitter::RateLimit.instance
      rate_limit.reset_at.should be_nil
    end
  end

  describe "#reset_in" do
    before do
      Timecop.freeze(Time.utc(2012, 6, 6, 17, 22, 0))
    end
    after do
      Timecop.return
    end
    it "returns an Integer when X-RateLimit-Reset header is set" do
      rate_limit = Twitter::RateLimit.instance.update('X-RateLimit-Reset' => "1339019097")
      rate_limit.reset_in.should be_an Integer
      rate_limit.reset_in.should eq 15777
    end
    it "returns nil when X-RateLimit-Reset header is not set" do
      rate_limit = Twitter::RateLimit.instance
      rate_limit.reset_in.should be_nil
    end
  end

end
