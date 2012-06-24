require 'helper'

describe Twitter::Client do
  before do
    @keys = Twitter::Configurable::VALID_OPTIONS_KEYS
  end

  context "with module configuration" do

    before do
      Twitter.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Twitter.reset!
    end

    it "inherits the module configuration" do
      api = Twitter::Client.new
      @keys.each do |key|
        api.send(key).should eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :connection_options => {:timeout => 10},
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :endpoint => 'http://tumblr.com/',
          :media_endpoint => 'https://upload.twitter.com/',
          :middleware => Proc.new{},
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          api = Twitter::Client.new(@configuration)
          @keys.each do |key|
            api.send(key).should eq @configuration[key]
          end
        end
      end

      context "after initilization" do
        it "overrides the module configuration after initialization" do
          api = Twitter::Client.new
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
          @keys.each do |key|
            api.send(key).should eq @configuration[key]
          end
        end
      end

    end
  end

  it "does not cache the screen name across clients" do
    stub_get("/1/account/verify_credentials.json").
      to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client1 = Twitter::Client.new
    client1.verify_credentials.screen_name.should eq 'sferik'
    stub_get("/1/account/verify_credentials.json").
      to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client2 = Twitter::Client.new
    client2.verify_credentials.screen_name.should eq 'pengwynn'
  end

  describe "#rate_limited?" do
    before do
      @client = Twitter::Client.new
    end
    it "returns true for rate limited methods" do
      @client.rate_limited?(:user).should be_true
    end
    it "returns false for rate limited methods" do
      @client.rate_limited?(:rate_limit_status).should be_false
    end
    it "returns for rate limited methods" do
      lambda do
        @client.rate_limited?(:foo)
      end.should raise_error(NameError, "no method `foo' for Twitter::Client")
    end
  end

end
