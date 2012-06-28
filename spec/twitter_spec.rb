require 'helper'

describe Twitter do

  after do
    Twitter.reset!
  end

  context "when delegating to a client" do

    before do
      stub_get("/1/statuses/user_timeline.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      Twitter.user_timeline('sferik')
      a_get("/1/statuses/user_timeline.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end

    it "returns the same results as a client" do
      Twitter.user_timeline('sferik').should eq Twitter::Client.new.user_timeline('sferik')
    end

  end

  describe '.respond_to?' do
    it "delegates to Twitter::Client" do
      Twitter.respond_to?(:user).should be_true
    end
    it "takes an optional argument" do
      Twitter.respond_to?(:client, true).should be_true
    end
  end

  describe ".client" do
    it "returns a Twitter::Client" do
      Twitter.client.should be_a Twitter::Client
    end
  end

  describe ".configure" do
    Twitter::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Twitter.configure do |config|
          config.send("#{key}=", key)
        end
        Twitter.instance_variable_get("@#{key}").should eq key
      end
    end
  end

  Twitter::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      Twitter.send(key).should eq Twitter::Default.const_get(key.to_s.upcase.to_sym)
    end
  end

end
