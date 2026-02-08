require "test_helper"

describe Twitter::Headers do
  before do
    @client = build_rest_client
    @headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
  end

  describe "#initialize" do
    it "stores the request method" do
      headers = Twitter::Headers.new(@client, :post, "#{Twitter::REST::Request::BASE_URL}/path")
      # The request_method is used in oauth_auth_header - SimpleOAuth upcases it
      assert_equal("POST", headers.oauth_auth_header.method)
    end

    it "stores the URL for oauth signature" do
      url = "#{Twitter::REST::Request::BASE_URL}/path?q=test"
      headers = Twitter::Headers.new(@client, :get, url)
      # Verify the URL is used in oauth_auth_header
      auth_header = headers.oauth_auth_header

      assert_kind_of(SimpleOAuth::Header, auth_header)
    end

    it "stores the URL as an Addressable::URI" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")

      assert_kind_of(Addressable::URI, headers.instance_variable_get(:@uri))
    end

    it "extracts bearer_token_request from options" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)

      assert_true(headers.bearer_token_request?)
    end

    it "stores remaining options" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", foo: "bar")
      # Options are used in oauth_auth_header
      auth_header = headers.oauth_auth_header

      assert_kind_of(SimpleOAuth::Header, auth_header)
    end
  end

  describe "#bearer_token_request?" do
    it "returns true when bearer_token_request option was set" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)

      assert_true(headers.bearer_token_request?)
    end

    it "returns false when bearer_token_request option was not set" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path")

      assert_false(headers.bearer_token_request?)
    end

    it "returns a strict boolean for truthy option values" do
      headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: "yes")

      assert_true(headers.bearer_token_request?)
    end
  end

  describe "#request_headers" do
    describe "when bearer_token_request is true" do
      it "returns headers with accept and basic authorization" do
        headers = Twitter::Headers.new(@client, :get, "#{Twitter::REST::Request::BASE_URL}/path", bearer_token_request: true)
        result = headers.request_headers

        assert_equal(@client.user_agent, result[:user_agent])
        assert_equal("*/*", result[:accept])
        assert_equal("Basic Q0s6Q1M=", result[:authorization])
      end
    end

    describe "when bearer_token_request is false" do
      it "returns headers with oauth authorization" do
        result = @headers.request_headers

        assert_equal(@client.user_agent, result[:user_agent])
        assert_nil(result[:accept])
        assert_match(/^OAuth /, result[:authorization])
      end
    end
  end

  describe "#oauth_auth_header" do
    it "creates the correct auth headers" do
      authorization = @headers.oauth_auth_header

      assert_equal("HMAC-SHA1", authorization.options[:signature_method])
      assert_equal("1.0", authorization.options[:version])
      assert_equal("CK", authorization.options[:consumer_key])
      assert_equal("CS", authorization.options[:consumer_secret])
      assert_equal("AT", authorization.options[:token])
      assert_equal("AS", authorization.options[:token_secret])
    end

    it "submits the correct auth header when no media is present" do
      # We use static values for nounce and timestamp to get a stable signature
      secret = {consumer_key: "CK", consumer_secret: "CS", token: "OT", token_secret: "OS", nonce: "b6ebe4c2a11af493f8a2290fe1296965", timestamp: "1370968658", ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="FbthwmgGq02iQw%2FuXGEWaL6V6eM%3D"/, content_type: "application/json; charset=utf-8"}
      stub_post("/1.1/statuses/update.json").with(body: {status: "Just a test"}).to_return(body: fixture("status.json"), headers:)
      @client.stub(:credentials, secret) do
        @client.update("Just a test")
      end

      assert_requested(a_post("/1.1/statuses/update.json").with(headers: {authorization: headers[:authorization]}))
    end

    it "submits the correct auth header when media is present" do
      secret = {consumer_key: "CK", consumer_secret: "CS", token: "OT", token_secret: "OS", nonce: "e08201ad0dab4897c99445056feefd95", timestamp: "1370967652", ignore_extra_keys: true}
      headers = {authorization: /oauth_signature="JVkElZ8O3WXkpZjtEHYRk67pYdQ%3D"/, content_type: "application/json; charset=utf-8"}
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: json_headers)
      @client.stub(:credentials, secret) do
        @client.update_with_media("Just a test", fixture_file("pbjt.gif"))
      end

      assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
      assert_requested(a_post("/1.1/statuses/update.json").with(headers: {authorization: headers[:authorization]}))
    end

    it "always passes ignore_extra_keys: true to SimpleOAuth::Header" do
      credentials = {consumer_key: "CK", consumer_secret: "CS", token: "AT", token_secret: "AS", extra: "value"}
      called = false
      header_object = Object.new
      header_object.define_singleton_method(:to_s) { "OAuth test" }

      @client.stub(:credentials, credentials) do
        SimpleOAuth::Header.stub(:new, lambda { |_method, _uri, _options, options|
          called = true

          assert(options[:ignore_extra_keys])
          assert_equal("value", options[:extra])
          header_object
        }) do
          @headers.oauth_auth_header
        end
      end

      assert(called)
    end
  end

  describe "#bearer_auth_header" do
    it "creates the correct auth headers with supplied bearer token" do
      client = Twitter::REST::Client.new(bearer_token: "BT")
      headers = Twitter::Headers.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = headers.send(:bearer_auth_header)

      assert_equal("Bearer BT", authorization)
    end
  end

  describe "#auth_header" do
    it "returns oauth header as string when user token is present" do
      authorization = @headers.send(:auth_header)

      assert_kind_of(String, authorization)
      assert_match(/^OAuth /, authorization)
    end

    it "fetches bearer token when not using user token and no bearer token set" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS")
      headers = Twitter::Headers.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = nil
      client.stub(:token, "fetched_bearer_token") do
        authorization = headers.send(:auth_header)
      end

      assert_equal("Bearer fetched_bearer_token", authorization)
      assert_equal("fetched_bearer_token", client.bearer_token)
    end

    it "does not fetch bearer token when bearer token is already set" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", bearer_token: "existing_token")
      headers = Twitter::Headers.new(client, :get, "#{Twitter::REST::Request::BASE_URL}/path")
      authorization = nil

      client.stub(:token, lambda {
        flunk("expected client#token not to be called when bearer token is already set")
      }) do
        authorization = headers.send(:auth_header)
      end

      assert_equal("Bearer existing_token", authorization)
    end
  end

  describe "#bearer_token_credentials_auth_header" do
    it "creates the correct auth header with supplied consumer_key and consumer_secret" do
      authorization = @headers.send(:bearer_token_credentials_auth_header)

      assert_equal("Basic Q0s6Q1M=", authorization)
    end
  end
end
