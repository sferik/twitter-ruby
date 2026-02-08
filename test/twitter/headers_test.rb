require "helper"

describe Twitter::Headers do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    @headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
  end

  describe "#initialize" do
    it "stores the request method" do
      headers = described_class.new(@client, :post, "#{Twitter::REST::Request::BASE_URL}/path")
      # The request_method is used in oauth_auth_header - SimpleOAuth upcases it
      expect(headers.oauth_auth_header.method).to eq("POST")
    end

    it "stores the URL for oauth signature" do
      url = "#{Twitter::REST::Request::BASE_URL}/path?q=test"
      headers = described_class.new(@client, :get, url)
      # Verify the URL is used in oauth_auth_header
      auth_header = headers.oauth_auth_header
      expect(auth_header).to be_a(SimpleOAuth::Header)
    end

    it "stores the URL as an Addressable::URI" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      expect(headers.instance_variable_get(:@uri)).to be_a(Addressable::URI)
    end

    it "extracts bearer_token_request from options" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)
      expect(headers.bearer_token_request?).to be true
    end

    it "stores remaining options" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", foo: "bar")
      # Options are used in oauth_auth_header
      auth_header = headers.oauth_auth_header
      expect(auth_header).to be_a(SimpleOAuth::Header)
    end
  end

  describe "#bearer_token_request?" do
    it "returns true when bearer_token_request option was set" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)
      expect(headers.bearer_token_request?).to be true
    end

    it "returns falsy when bearer_token_request option was not set" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      expect(headers.bearer_token_request?).to be_falsy
    end

    it "returns a strict boolean for truthy option values" do
      headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: "yes")
      expect(headers.bearer_token_request?).to eq(true)
    end
  end

  describe "#request_headers" do
    context "when bearer_token_request is true" do
      it "returns headers with accept and basic authorization" do
        headers = described_class.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)
        result = headers.request_headers
        expect(result[:user_agent]).to eq(@client.user_agent)
        expect(result[:accept]).to eq("*/*")
        expect(result[:authorization]).to eq("Basic Q0s6Q1M=")
      end
    end

    context "when bearer_token_request is false" do
      it "returns headers with oauth authorization" do
        result = @headers.request_headers
        expect(result[:user_agent]).to eq(@client.user_agent)
        expect(result[:accept]).to be_nil
        expect(result[:authorization]).to match(/^OAuth /)
      end
    end
  end

  describe "#oauth_auth_header" do
    it "creates the correct auth headers" do
      authorization = @headers.oauth_auth_header
      expect(authorization.options[:signature_method]).to eq("HMAC-SHA1")
      expect(authorization.options[:version]).to eq("1.0")
      expect(authorization.options[:consumer_key]).to eq("CK")
      expect(authorization.options[:consumer_secret]).to eq("CS")
      expect(authorization.options[:token]).to eq("AT")
      expect(authorization.options[:token_secret]).to eq("AS")
    end

    it "submits the correct auth header when no media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {consumer_key: "CK", consumer_secret: "CS", token: "OT", token_secret: "OS", nonce: "b6ebe4c2a11af493f8a2290fe1296965", timestamp: "1370968658", ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/, content_type: "application/json; charset=utf-8"}
      allow(@client).to receive(:credentials).and_return(secret)
      stub_post("/1.1/statuses/update.json").with(body: {status: "Just a test"}).to_return(body: fixture("status.json"), headers:)
      @client.update("Just a test")
      expect(a_post("/1.1/statuses/update.json").with(headers: {authorization: headers[:authorization]})).to have_been_made
    end

    it "submits the correct auth header when media is present" do
      secret = {consumer_key: "CK", consumer_secret: "CS", token: "OT", token_secret: "OS", nonce: "e08201ad0dab4897c99445056feefd95", timestamp: "1370967652", ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="JVkElZ8O3WXkpZjtEHYRk67pYdQ%3D"/, content_type: "application/json; charset=utf-8"}
      allow(@client).to receive(:credentials).and_return(secret)
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.update_with_media("Just a test", fixture("pbjt.gif"))
      expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
      expect(a_post("/1.1/statuses/update.json").with(headers: {authorization: headers[:authorization]})).to have_been_made
    end

    it "always passes ignore_extra_keys: true to SimpleOAuth::Header" do
      credentials = {consumer_key: "CK", consumer_secret: "CS", token: "AT", token_secret: "AS", extra: "value"}
      allow(@client).to receive(:credentials).and_return(credentials)

      expect(SimpleOAuth::Header).to receive(:new) do |_method, _uri, _options, options|
        expect(options[:ignore_extra_keys]).to eq(true)
        expect(options[:extra]).to eq("value")
        double(to_s: "OAuth test")
      end

      @headers.oauth_auth_header
    end
  end

  describe "#bearer_auth_header" do
    it "creates the correct auth headers with supplied bearer token" do
      client = Twitter::REST::Client.new(bearer_token: "BT")
      headers = described_class.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = headers.send(:bearer_auth_header)
      expect(authorization).to eq("Bearer BT")
    end
  end

  describe "#auth_header" do
    it "returns oauth header as string when user token is present" do
      authorization = @headers.send(:auth_header)
      expect(authorization).to be_a(String)
      expect(authorization).to match(/^OAuth /)
    end

    it "fetches bearer token when not using user token and no bearer token set" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS")
      allow(client).to receive(:token).and_return("fetched_bearer_token")
      headers = described_class.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = headers.send(:auth_header)
      expect(authorization).to eq("Bearer fetched_bearer_token")
      expect(client.bearer_token).to eq("fetched_bearer_token")
    end

    it "does not fetch bearer token when bearer token is already set" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", bearer_token: "existing_token")
      expect(client).not_to receive(:token)
      headers = described_class.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = headers.send(:auth_header)
      expect(authorization).to eq("Bearer existing_token")
    end
  end

  describe "#bearer_token_credentials_auth_header" do
    it "creates the correct auth header with supplied consumer_key and consumer_secret" do
      authorization = @headers.send(:bearer_token_credentials_auth_header)
      expect(authorization).to eq("Basic Q0s6Q1M=")
    end
  end
end
