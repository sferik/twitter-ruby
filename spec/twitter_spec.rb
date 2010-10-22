require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Twitter" do

  after do
    Twitter.reset
  end

  describe ".client" do
    it "should be a Twitter::Client" do
      Twitter.client.should be_a Twitter::Client
    end
  end

  describe ".adapter" do
    it "should be set to Net::HTTP by default" do
      Twitter.adapter.should == :net_http
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Twitter.adapter = :typhoeus
      Twitter.adapter.should == :typhoeus
    end
  end

  describe ".endpoint" do
    it "should be set to https://api.twitter.com/1/ by default" do
      Twitter.endpoint.should == 'https://api.twitter.com/1/'
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Twitter.endpoint = 'http://tumblr.com/'
      Twitter.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".format" do
    it "should be set to JSON by default" do
      Twitter.format.should == 'json'
    end
  end

  describe ".format=" do
    it "should set the format" do
      Twitter.format = 'xml'
      Twitter.format.should == 'xml'
    end
  end

  describe ".user_agent" do
    it "should be set to Twitter Ruby Gem by default" do
      Twitter.user_agent.should == "Twitter Ruby Gem #{Twitter::VERSION}"
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Twitter.user_agent = 'Custom User Agent'
      Twitter.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do

    Twitter::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Twitter.configure do |config|
          config.send("#{key}=", key)
          Twitter.send(key).should == key
        end
      end

    end

  end

end
