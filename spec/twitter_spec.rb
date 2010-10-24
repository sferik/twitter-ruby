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
    it "should return the default adapter" do
      Twitter.adapter.should == Twitter::Configuration::DEFAULT_ADAPTER
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
      Twitter.endpoint.should == Twitter::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Twitter.endpoint = 'http://tumblr.com/'
      Twitter.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".format" do
    it "should return the default format" do
      Twitter.format.should == Twitter::Configuration::DEFAULT_FORMAT
    end
  end

  describe ".format=" do
    it "should set the format" do
      Twitter.format = 'xml'
      Twitter.format.should == 'xml'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Twitter.user_agent.should == Twitter::Configuration::DEFAULT_USER_AGENT
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
