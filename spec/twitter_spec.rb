require 'helper'

describe Twitter do
  after do
    Twitter.reset
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
    it "takes an optional argument" do
      Twitter.respond_to?(:new, true).should be_true
    end
  end

  describe ".new" do
    it "returns a Twitter::Client" do
      Twitter.new.should be_a Twitter::Client
    end
  end

  describe ".endpoint" do
    it "returns the default endpoint" do
      Twitter.endpoint.should eq Twitter::Config::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "sets the endpoint" do
      Twitter.endpoint = 'http://tumblr.com/'
      Twitter.endpoint.should eq 'http://tumblr.com/'
    end
  end

  describe ".user_agent" do
    it "returns the default user agent" do
      Twitter.user_agent.should eq Twitter::Config::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "sets the user_agent" do
      Twitter.user_agent = 'Custom User Agent'
      Twitter.user_agent.should eq 'Custom User Agent'
    end
  end

  describe '.middleware' do
    it "returns a Faraday::Builder" do
      Twitter.middleware.should be_kind_of(Faraday::Builder)
    end
  end

  describe ".configure" do
    Twitter::Config::VALID_OPTIONS_KEYS.each do |key|
      it "sets the #{key}" do
        Twitter.configure do |config|
          config.send("#{key}=", key)
          Twitter.send(key).should eq key
        end
      end
    end
  end

end
