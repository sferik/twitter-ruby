require File.expand_path('../../spec_helper', __FILE__)

describe "Twitter::Client" do
  before do
    @keys = Twitter::Configuration::VALID_OPTIONS_KEYS
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
      Twitter.reset
    end

    it "should inherit module configuration" do
      client = Twitter::Client.new
      @keys.each do |key|
        client.send(key).should == key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
          :adapter => :typhoeus,
          :endpoint => 'http://tumblr.com/',
          :format => :xml,
          :user_agent => 'Custom User Agent',
        }
      end

      context "during initialization"

        it "should override module configuration" do
          client = Twitter::Client.new(@configuration)
          @keys.each do |key|
            client.send(key).should == @configuration[key]
          end
        end

      context "after initilization" do

        it "should override module configuration after initialization" do
          client = Twitter::Client.new
          @configuration.each do |key, value|
            client.send("#{key}=", value)
          end
          @keys.each do |key|
            client.send(key).should == @configuration[key]
          end
        end
      end
    end
  end
end
