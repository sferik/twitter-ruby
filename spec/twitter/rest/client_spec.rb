require 'helper'

describe Twitter::REST::Client do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe ".new" do
    context "when invalid credentials are provided" do
      it "raises a ConfigurationError exception" do
        expect {
          Twitter::REST::Client.new(:consumer_key => [12345, 54321])
        }.to raise_exception(Twitter::Error::ConfigurationError)
      end
    end

    context "when no credentials are provided" do
      it "does not raise an exception" do
        expect {
          Twitter::REST::Client.new
        }.not_to raise_error
      end
    end
  end

  describe ".credentials?" do
    it "returns true if only bearer_token is supplied" do
      client = Twitter::REST::Client.new(:bearer_token => "BT")
      expect(client.credentials?).to be_true
    end
    it "returns true if all OAuth credentials are present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
      expect(client.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT")
      expect(client.credentials?).to be_false
    end
  end

  it "does not cache the screen name across clients" do
    stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    user1 = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS").current_user
    stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("pengwynn.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    user2 = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS").current_user
    expect(user1).not_to eq(user2)
  end

  describe "#delete" do
    before do
      stub_delete("/custom/delete").with(:query => {:deleted => "object"})
    end
    it "allows custom delete requests" do
      @client.delete("/custom/delete", {:deleted => "object"})
      expect(a_delete("/custom/delete").with(:query => {:deleted => "object"})).to have_been_made
    end
  end

  describe "#put" do
    before do
      stub_put("/custom/put").with(:body => {:updated => "object"})
    end
    it "allows custom put requests" do
      @client.put("/custom/put", {:updated => "object"})
      expect(a_put("/custom/put").with(:body => {:updated => "object"})).to have_been_made
    end
  end

  describe "#user_token?" do
    it "returns true if the user token/secret are present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
      expect(client.user_token?).to be_true
    end
    it "returns false if the user token/secret are not completely present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT")
      expect(client.user_token?).to be_false
    end
  end

  describe "#bearer_token?" do
    it "returns true if the app token is present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :bearer_token => "BT")
      expect(client.bearer_token?).to be_true
    end
    it "returns false if the bearer_token is not present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS")
      expect(client.bearer_token?).to be_false
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
      expect(client.credentials?).to be_true
    end
    it "returns false if any credentials are missing" do
      client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT")
      expect(client.credentials?).to be_false
    end
  end

  describe "#connection" do
    it "looks like Faraday connection" do
      expect(@client.send(:connection)).to respond_to(:run_request)
    end
    it "memoizes the connection" do
      c1, c2 = @client.send(:connection), @client.send(:connection)
      expect(c1.object_id).to eq(c2.object_id)
    end
  end

  describe "#request" do
    it "encodes the entire body when no uploaded media is present" do
      stub_post("/1.1/statuses/update.json").with(:body => {:status => "Update"}).to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update("Update")
      expect(a_post("/1.1/statuses/update.json").with(:body => {:status => "Update"})).to have_been_made
    end
    it "encodes none of the body when uploaded media is present" do
      stub_post("/1.1/statuses/update_with_media.json").to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update_with_media("Update", fixture("pbjt.gif"))
      expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
    end
    it "catches Faraday errors" do
      allow(@client).to receive(:connection).and_raise(Faraday::Error::ClientError.new("Oops"))
      expect{@client.send(:request, :get, "/path")}.to raise_error Twitter::Error
    end
    it "catches JSON::ParserError errors" do
      allow(@client).to receive(:connection).and_raise(JSON::ParserError.new("unexpected token"))
      expect{@client.send(:request, :get, "/path")}.to raise_error Twitter::Error
    end
  end

  describe "#oauth_auth_header" do
    it "creates the correct auth headers" do
      uri = Twitter::REST::Client::ENDPOINT + "/1.1/direct_messages.json"
      authorization = @client.send(:oauth_auth_header, :get, uri)
      expect(authorization.options[:signature_method]).to eq("HMAC-SHA1")
      expect(authorization.options[:version]).to eq("1.0")
      expect(authorization.options[:consumer_key]).to eq("CK")
      expect(authorization.options[:consumer_secret]).to eq("CS")
      expect(authorization.options[:token]).to eq("AT")
      expect(authorization.options[:token_secret]).to eq("AS")
    end
    it "submits the correct auth header when no media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {:consumer_key => "CK", :consumer_secret => "CS",
                :token => "OT", :token_secret => "OS",
                :nonce => "b6ebe4c2a11af493f8a2290fe1296965", :timestamp => "1370968658"}
      header = {"Authorization" => /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/}

      allow(@client).to receive(:credentials).and_return(secret)
      stub_post("/1.1/statuses/update.json").with(:body => {:status => "Just a test"}).to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @client.update("Just a test")
      expect(a_post("/1.1/statuses/update.json").
             with(:headers => header)).to have_been_made
    end
    it "submits the correct auth header when media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {:consumer_key => "CK", :consumer_secret => "CS",
                :token => "OT", :token_secret => "OS",
                :nonce => "e08201ad0dab4897c99445056feefd95", :timestamp => "1370967652"}
      header = {"Authorization" => /oauth_signature="9ziouUPwZT9IWWRbJL8r0BerKYA%3D"/}

      allow(@client).to receive(:credentials).and_return(secret)
      stub_post("/1.1/statuses/update_with_media.json").to_return(:body => fixture("status.json"), :headers => header)
      @client.update_with_media("Just a test", fixture("pbjt.gif"))
      expect(a_post("/1.1/statuses/update_with_media.json").
             with(:headers => header)).to have_been_made
    end
  end

  describe "#bearer_auth_header" do
    it "creates the correct auth headers with supplied bearer_token" do
      client = Twitter::REST::Client.new(:bearer_token => "BT")
      authorization = client.send(:bearer_auth_header)
      expect(authorization).to eq("Bearer BT")
    end
    it "creates the correct auth headers with supplied bearer token" do
      token = Twitter::Token.new(:token_type => "bearer", :access_token => "BT")
      client = Twitter::REST::Client.new(:bearer_token => token)
      authorization = client.send(:bearer_auth_header)
      expect(authorization).to eq("Bearer BT")
    end
  end

  describe "#bearer_token_credentials_auth_header" do
    it "creates the correct auth header with supplied consumer_key and consumer_secret" do
      authorization = @client.send(:bearer_token_credentials_auth_header)
      expect(authorization).to eq("Basic Q0s6Q1M=")
    end
  end
end
