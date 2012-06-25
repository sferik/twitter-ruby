require 'helper'

describe Twitter::Client do

  subject do
    client = Twitter::Client.new
    client.class_eval{public *Twitter::Client.private_instance_methods}
    client
  end

  context "with module configuration" do

    before do
      Twitter.configure do |config|
        Twitter::Configurable.keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Twitter.reset!
    end

    it "doesn't inherit the module configuration" do
      client = Twitter::Client.new
      Twitter::Configurable.keys.each do |key|
        client.instance_variable_get("@#{key}").should_not eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :connection_options => {:timeout => 10},
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :endpoint => 'http://tumblr.com/',
          :media_endpoint => 'https://upload.twitter.com',
          :middleware => Proc.new{},
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          client = Twitter::Client.new(@configuration)
          Twitter::Configurable.keys.each do |key|
            client.instance_variable_get("@#{key}").should eq @configuration[key]
          end
        end
      end

      context "after initilization" do
        it "overrides the module configuration after initialization" do
          client = Twitter::Client.new
          client.configure do |config|
            @configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          Twitter::Configurable.keys.each do |key|
            client.instance_variable_get("@#{key}").should eq @configuration[key]
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
    it "raises an ArgumentError for non-existant methods" do
      lambda do
        @client.rate_limited?(:foo)
      end.should raise_error(ArgumentError, "no method `foo' for Twitter::Client")
    end
  end

  describe "#put" do
    before do
      @client = Twitter::Client.new
      stub_put("/custom/put").
        with(:body => {:updated => "object"})
    end
    it "allows custom put requests" do
      @client.put("/custom/put", {:updated => "object"})
      a_put("/custom/put").
        with(:body => {:updated => "object"}).
        should have_been_made
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      client.credentials?.should be_true
    end
    it "returns false if any credentials are missing" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT')
      client.credentials?.should be_false
    end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      subject.connection.should respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.connection, subject.connection
      c1.object_id.should eq c2.object_id
    end
  end

  describe "#request" do
    before do
      @client = Twitter::Client.new({:consumer_key => "CK", :consumer_secret => "CS", :oauth_token => "OT", :oauth_token_secret => "OS"})
    end
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1/statuses/update.json").
        with(:body => {:status => "Update"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update("Update")
      a_post("/1/statuses/update.json").
        with(:body => {:status => "Update"}).
        should have_been_made
    end
    it "encodes none of the body when uploaded media is present" do
      stub_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("pbjt.gif"))
      a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
        should have_been_made
    end
    it "catches Faraday errors" do
      subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oups"))
      lambda do
        subject.request(:get, "/path", {}, {})
      end.should raise_error(Twitter::Error::ClientError, "Oups")
    end
  end

  Twitter::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      subject.send(key).should eq Twitter::Default.const_get(key.to_s.upcase.to_sym)
    end
  end

end
