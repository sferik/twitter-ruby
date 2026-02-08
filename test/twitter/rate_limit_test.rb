require "test_helper"

describe Twitter::RateLimit do
  describe "#limit" do
    it "returns an Integer when x-rate-limit-limit header is set" do
      rate_limit = Twitter::RateLimit.new("x-rate-limit-limit" => "150")

      assert_kind_of(Integer, rate_limit.limit)
      assert_equal(150, rate_limit.limit)
    end

    it "returns nil when x-rate-limit-limit header is not set" do
      rate_limit = Twitter::RateLimit.new

      assert_nil(rate_limit.limit)
    end
  end

  describe "#remaining" do
    it "returns an Integer when x-rate-limit-remaining header is set" do
      rate_limit = Twitter::RateLimit.new("x-rate-limit-remaining" => "149")

      assert_kind_of(Integer, rate_limit.remaining)
      assert_equal(149, rate_limit.remaining)
    end

    it "returns nil when x-rate-limit-remaining header is not set" do
      rate_limit = Twitter::RateLimit.new

      assert_nil(rate_limit.remaining)
    end
  end

  describe "#reset_at" do
    it "returns a Time when x-rate-limit-reset header is set" do
      rate_limit = Twitter::RateLimit.new("x-rate-limit-reset" => "1339019097")

      assert_kind_of(Time, rate_limit.reset_at)
      assert_predicate(rate_limit.reset_at, :utc?)
      assert_equal(Time.at(1_339_019_097), rate_limit.reset_at)
    end

    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = Twitter::RateLimit.new

      assert_nil(rate_limit.reset_at)
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
      rate_limit = Twitter::RateLimit.new("x-rate-limit-reset" => "1339019097")

      assert_kind_of(Integer, rate_limit.reset_in)
      assert_equal(15_777, rate_limit.reset_in)
    end

    it "returns nil when x-rate-limit-reset header is not set" do
      rate_limit = Twitter::RateLimit.new

      assert_nil(rate_limit.reset_in)
    end

    it "returns 0 when reset time is in the past" do
      past_reset = Time.utc(2012, 6, 6, 17, 20, 0).to_i.to_s
      rate_limit = Twitter::RateLimit.new("x-rate-limit-reset" => past_reset)

      assert_equal(0, rate_limit.reset_in)
    end
  end
end
