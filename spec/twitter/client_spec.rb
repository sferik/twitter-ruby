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

    it "inherits the module configuration" do
      api = Twitter::Client.new
      @keys.each do |key|
        api.send(key).should eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :endpoint => 'http://tumblr.com/',
          :media_endpoint => 'https://upload.twitter.com/',
          :middleware => Proc.new{},
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
          :proxy => 'http://erik:sekret@proxy.example.com:8080',
          :user_agent => 'Custom User Agent',
          :connection_options => {:timeout => 10},
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
    client1.current_user.screen_name.should eq 'sferik'
    stub_get("/1/account/verify_credentials.json").
      to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client2 = Twitter::Client.new
    client2.current_user.screen_name.should eq 'pengwynn'
  end

  it "recursively merges connection options" do
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
