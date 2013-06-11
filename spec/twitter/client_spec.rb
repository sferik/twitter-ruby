require 'helper'

describe Twitter::Client do

  subject do
    Twitter::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :oauth_token => "OT", :oauth_token_secret => "OS")
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

    it "inherits the module configuration" do
      client = Twitter::Client.new
      Twitter::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq key
      end
    end

    context "with class configuration" do

      before do
        @configuration = {
          :connection_options => {:timeout => 10},
          :consumer_key => 'CK',
          :consumer_secret => 'CS',
          :endpoint => 'http://tumblr.com/',
          :middleware => Proc.new{},
          :oauth_token => 'OT',
          :oauth_token_secret => 'OS',
          :bearer_token => 'BT',
          :identity_map => ::Hash
        }
      end

      context "during initialization" do
        it "overrides the module configuration" do
          client = Twitter::Client.new(@configuration)
          Twitter::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end

      context "after initialization" do
        it "overrides the module configuration after initialization" do
          client = Twitter::Client.new
          client.configure do |config|
            @configuration.each do |key, value|
              config.send("#{key}=", value)
            end
          end
          Twitter::Configurable.keys.each do |key|
            expect(client.instance_variable_get(:"@#{key}")).to eq @configuration[key]
          end
        end
      end

    end
  end

  it "does not cache the screen name across clients" do
    stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client1 = Twitter::Client.new
    expect(client1.verify_credentials.id).to eq 7505382
    stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    client2 = Twitter::Client.new
    expect(client2.verify_credentials.id).to eq 14100886
  end

  describe "#delete" do
    before do
      stub_delete("/custom/delete").with(:query => {:deleted => "object"})
    end
    it "allows custom delete requests" do
      subject.delete("/custom/delete", {:deleted => "object"})
      expect(a_delete("/custom/delete").with(:query => {:deleted => "object"})).to have_been_made
    end
  end

  describe "#put" do
    before do
      stub_put("/custom/put").with(:body => {:updated => "object"})
    end
    it "allows custom put requests" do
      subject.put("/custom/put", {:updated => "object"})
      expect(a_put("/custom/put").with(:body => {:updated => "object"})).to have_been_made
    end
  end

  describe "#user_token?" do
    it "returns true if the user token/secret are present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      expect(client.user_token?).to be_true
    end
    it "returns false if the user token/secret are not completely present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT')
      expect(client.user_token?).to be_false
    end
  end

  describe "#bearer_token?" do
    it "returns true if the app token is present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :bearer_token => 'BT')
      expect(client.bearer_token?).to be_true
    end
    it "returns false if the bearer_token is not present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS')
      expect(client.bearer_token?).to be_false
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
      expect(client.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      client = Twitter::Client.new(:consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT')
      expect(client.credentials?).to be_false
    end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      expect(subject.send(:connection)).to respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = subject.send(:connection), subject.send(:connection)
      expect(c1.object_id).to eq c2.object_id
    end
  end

  describe "#request" do
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1.1/statuses/update.json").with(:body => {:status => "Update"}).to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      subject.update("Update")
      expect(a_post("/1.1/statuses/update.json").with(:body => {:status => "Update"})).to have_been_made
    end
    it "encodes none of the body when uploaded media is present" do
      stub_post("/1.1/statuses/update_with_media.json")
      subject.update_with_media("Update", fixture("pbjt.gif"))
      expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
    end
    it "catches Faraday errors" do
      subject.stub!(:connection).and_raise(Faraday::Error::ClientError.new("Oops"))
      expect{subject.send(:request, :get, "/path")}.to raise_error Twitter::Error::ClientError
    end
    it "catches MultiJson::DecodeError errors" do
      subject.stub!(:connection).and_raise(MultiJson::DecodeError.new("unexpected token", [], "<!DOCTYPE html>"))
      expect{subject.send(:request, :get, "/path")}.to raise_error Twitter::Error::DecodeError
    end
  end

  describe "#oauth_auth_header" do
    it "creates the correct auth headers" do
      uri = "/1.1/direct_messages.json"
      authorization = subject.send(:oauth_auth_header, :get, uri)
      expect(authorization.options[:signature_method]).to eq "HMAC-SHA1"
      expect(authorization.options[:version]).to eq "1.0"
      expect(authorization.options[:consumer_key]).to eq "CK"
      expect(authorization.options[:consumer_secret]).to eq "CS"
      expect(authorization.options[:token]).to eq "OT"
      expect(authorization.options[:token_secret]).to eq "OS"
    end
    it "submits the correct auth header when no media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {:consumer_key => 'CK', :consumer_secret => 'CS',
                :token => 'OT', :token_secret => 'OS',
                :nonce => 'b6ebe4c2a11af493f8a2290fe1296965', :timestamp => '1370968658'}
      header = {"Authorization" => /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/}

      subject.stub(:credentials).and_return(secret)
      stub_post("/1.1/statuses/update.json")
      subject.update("Just a test")
      expect(a_post("/1.1/statuses/update.json").
             with(:headers => header)).to have_been_made
    end
    it "submits the correct auth header when media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {:consumer_key => 'CK', :consumer_secret => 'CS',
                :token => 'OT', :token_secret => 'OS',
                :nonce => 'e08201ad0dab4897c99445056feefd95', :timestamp => '1370967652'}
      header = {"Authorization" => /oauth_signature="9ziouUPwZT9IWWRbJL8r0BerKYA%3D"/}

      subject.stub(:credentials).and_return(secret)
      stub_post("/1.1/statuses/update_with_media.json")
      subject.update_with_media("Just a test", fixture("pbjt.gif"))
      expect(a_post("/1.1/statuses/update_with_media.json").
             with(:headers => header)).to have_been_made
    end
  end

  describe "#bearer_auth_header" do
    subject do
      Twitter::Client.new(:bearer_token => "BT")
    end

    it "creates the correct auth headers with supplied bearer_token" do
      uri = "/1.1/direct_messages.json"
      authorization = subject.send(:bearer_auth_header)
      expect(authorization).to eq "Bearer BT"
    end
  end

  describe "#bearer_token_credentials_auth_header" do
    it "creates the correct auth header with supplied consumer_key and consumer_secret" do
      uri = "/1.1/direct_messages.json"
      authorization = subject.send(:bearer_token_credentials_auth_header)
      expect(authorization).to eq "Basic Q0s6Q1M="
    end
  end
end
