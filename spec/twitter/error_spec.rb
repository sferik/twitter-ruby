require 'helper'

describe Twitter::Error do

  describe "#initialize" do
    it "wraps another error class" do
      begin
        raise Faraday::Error::ClientError.new("Oups")
      rescue Faraday::Error::ClientError
        begin
          raise Twitter::Error
        rescue Twitter::Error => error
          error.message.should eq "Oups"
          error.wrapped_exception.class.should eq Faraday::Error::ClientError
        end
      end
    end
  end

  describe "#ratelimit_reset" do
    it "returns a Time when X-RateLimit-Reset header is set" do
      error = Twitter::Error.new("Error", {'X-RateLimit-Reset' => "1339019097"})
      error.ratelimit_reset.should be_a Time
      error.ratelimit_reset.should eq Time.at(1339019097)
    end
    it "returns nil when X-RateLimit-Reset header is not set" do
      error = Twitter::Error.new("Error", {})
      error.ratelimit_reset.should be_nil
    end
  end

  describe "#ratelimit_class" do
    it "returns a String when X-RateLimit-Class header is set" do
      error = Twitter::Error.new("Error", {'X-RateLimit-Class' => "api"})
      error.ratelimit_class.should be_an String
      error.ratelimit_class.should eq "api"
    end
    it "returns nil when X-RateLimit-Class header is not set" do
      error = Twitter::Error.new("Error", {})
      error.ratelimit_class.should be_nil
    end
  end

  describe "#ratelimit_limit" do
    it "returns an Integer when X-RateLimit-Limit header is set" do
      error = Twitter::Error.new("Error", {'X-RateLimit-Limit' => "150"})
      error.ratelimit_limit.should be_an Integer
      error.ratelimit_limit.should eq 150
    end
    it "returns nil when X-RateLimit-Limit header is not set" do
      error = Twitter::Error.new("Error", {})
      error.ratelimit_limit.should be_nil
    end
  end

  describe "#ratelimit_remaining" do
    it "returns an Integer when X-RateLimit-Remaining header is set" do
      error = Twitter::Error.new("Error", {'X-RateLimit-Remaining' => "149"})
      error.ratelimit_remaining.should be_an Integer
      error.ratelimit_remaining.should eq 149
    end
    it "returns nil when X-RateLimit-Remaining header is not set" do
      error = Twitter::Error.new("Error", {})
      error.ratelimit_remaining.should be_nil
    end
  end

  describe "#retry_after" do
    before do
      Timecop.freeze(Time.utc(2012, 6, 6, 17, 22, 0))
    end
    after do
      Timecop.return
    end
    it "returns an Integer when X-RateLimit-Reset header is set" do
      error = Twitter::Error.new("Error", {'X-RateLimit-Reset' => "1339019097"})
      error.retry_after.should be_an Integer
      error.retry_after.should eq 15777
    end
    it "returns nil when X-RateLimit-Reset header is not set" do
      error = Twitter::Error.new("Error", {})
      error.retry_after.should be_nil
    end
  end

end
