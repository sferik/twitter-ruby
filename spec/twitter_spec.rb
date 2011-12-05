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

    it "should request the correct resource" do
      Twitter.user_timeline('sferik')
      a_get("/1/statuses/user_timeline.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end

    it "should return the same results as a client" do
      Twitter.user_timeline('sferik').should == Twitter::Client.new.user_timeline('sferik')
    end

  end

  describe '.respond_to?' do
    it "should take an optional argument" do
      Twitter.respond_to?(:new, true).should be_true
    end
  end

  describe ".new" do
    it "should return a Twitter::Client" do
      Twitter.new.should be_a Twitter::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Twitter.adapter.should == Twitter::Config::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Twitter.adapter = :typhoeus
      Twitter.adapter.should == :typhoeus
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Twitter.endpoint.should == Twitter::Config::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Twitter.endpoint = 'http://tumblr.com/'
      Twitter.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Twitter.user_agent.should == Twitter::Config::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Twitter.user_agent = 'Custom User Agent'
      Twitter.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do
    Twitter::Config::VALID_OPTIONS_KEYS.each do |key|
      it "should set the #{key}" do
        Twitter.configure do |config|
          config.send("#{key}=", key)
          Twitter.send(key).should == key
        end
      end
    end
  end

end
