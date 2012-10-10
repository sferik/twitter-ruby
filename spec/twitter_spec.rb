require 'helper'

describe Twitter do

  after do
    Twitter.reset!
  end

  context "when delegating to a client" do

    before do
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      Twitter.user_timeline('sferik')
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"})).to have_been_made
    end

    it "returns the same results as a client" do
      expect(Twitter.user_timeline('sferik')).to eq Twitter::Client.new.user_timeline('sferik')
    end

  end

  describe ".respond_to?" do
    it "delegates to Twitter::Client" do
      expect(Twitter.respond_to?(:user)).to be_true
    end
    it "takes an optional argument" do
      expect(Twitter.respond_to?(:client, true)).to be_true
    end
  end

  describe ".client" do
    it "returns a Twitter::Client" do
      expect(Twitter.client).to be_a Twitter::Client
    end

    context "when the options don't change" do
      it "caches the client" do
        expect(Twitter.client).to eq Twitter.client
      end
    end
    context "when the options change" do
      it "busts the cache" do
        client1 = Twitter.client
        Twitter.configure do |config|
          config.consumer_key = 'abc'
          config.consumer_secret = '123'
        end
        client2 = Twitter.client
        expect(client1).not_to eq client2
      end
    end
  end

  describe ".configure" do
    Twitter::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Twitter.configure do |config|
          config.send("#{key}=", key)
        end
        expect(Twitter.instance_variable_get(:"@#{key}")).to eq key
      end
    end
  end

  describe ".credentials?" do
    it "returns true if all credentials are present" do
      Twitter.configure do |config|
        config.consumer_key = 'CK'
        config.consumer_secret = 'CS'
        config.oauth_token = 'OT'
        config.oauth_token_secret = 'OS'
      end
      expect(Twitter.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      Twitter.configure do |config|
        config.consumer_key = 'CK'
        config.consumer_secret = 'CS'
        config.oauth_token = 'OT'
      end
      expect(Twitter.credentials?).to be_false
    end
  end

end
