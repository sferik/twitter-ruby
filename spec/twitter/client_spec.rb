require 'helper'

describe Twitter::Client do
  before do
    @keys = Twitter::Config::VALID_OPTIONS_KEYS
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
      api = Twitter::Client.new
      @keys.each do |key|
        api.send(key).should == key
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
          :gateway => 'apigee-1111.apigee.com',
          :proxy => 'http://erik:sekret@proxy.example.com:8080',
          :search_endpoint => 'http://google.com/',
          :media_endpoint => 'https://upload.twitter.com/',
          :user_agent => 'Custom User Agent',
          :connection_options => {:timeout => 10},
        }
      end

      context "during initialization" do
        it "should override module configuration" do
          api = Twitter::Client.new(@configuration)
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end
      end

      context "after initilization" do
        it "should override module configuration after initialization" do
          api = Twitter::Client.new
          @configuration.each do |key, value|
            api.send("#{key}=", value)
          end
          @keys.each do |key|
            api.send(key).should == @configuration[key]
          end
        end
      end

    end
  end

  it "should not cache the screen name across clients" do
    stub_get("/1/account/verify_credentials.json").
      to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client1 = Twitter::Client.new
    client1.current_user.screen_name.should == 'sferik'
    stub_get("/1/account/verify_credentials.json").
      to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client2 = Twitter::Client.new
    client2.current_user.screen_name.should == 'pengwynn'
  end

  it "should recursively merge connection options" do
    stub_get("/1/statuses/user_timeline.json").
      with(:query => {:screen_name => "sferik"}, :headers => {"Accept" => "application/json", "User-Agent" => "Custom User Agent"}).
      to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client = Twitter::Client.new(:connection_options => {:headers => {:user_agent => 'Custom User Agent'}})
    client.user_timeline("sferik")
    a_get("/1/statuses/user_timeline.json").
      with(:query => {:screen_name => "sferik"}, :headers => {"User-Agent" => "Custom User Agent"}).
      should have_been_made
  end

end
