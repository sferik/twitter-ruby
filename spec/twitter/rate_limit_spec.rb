require 'helper'

describe Twitter::RateLimit do

  describe "#limit" do
    it "returns an Integer when x-rate-limit-limit header is set" do
      rate_limit = Twitter::RateLimit.new('x-rate-limit-limit' => "150")
      rate_limit.limit.should be_an Integer
      rate_limit.limit.should eq 150
    end
    it "returns nil when x-rate-limit-limit header is not set" do
      rate_limit = Twitter::RateLimit.new
      rate_limit.limit.should be_nil
    end
  end

  describe "#remaining" do
    it "returns an Integer when x-rate-limit-remaining header is set" do
      rate_limit = Twitter::RateLimit.new('x-rate-limit-remaining' => "149")
      rate_limit.remaining.should be_an Integer
      rate_limit.remaining.should eq 149
    end
    it "returns nil when x-rate-limit-remaining header is not set" do
      rate_limit = Twitter::RateLimit.new
      rate_limit.remaining.should be_nil
    end
  end

  describe "#reset_at" do
    it "returns a Time when x-rate-limit-reset header is set" do
      rate_limit = Twitter::RateLimit.new('x-rate-limit-reset' => "1339019097")
      rate_limit.reset_at.should be_a Time
      rate_limit.reset_at.should eq Time.at(1339019097)
    end
    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = Twitter::RateLimit.new
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
    it "returns an Integer when x-rate-limit-reset header is set" do
      rate_limit = Twitter::RateLimit.new('x-rate-limit-reset' => "1339019097")
      rate_limit.reset_in.should be_an Integer
      rate_limit.reset_in.should eq 15777
    end
    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = Twitter::RateLimit.new
      rate_limit.reset_in.should be_nil
    end
  end

end
