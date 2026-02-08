require "test_helper"

describe Twitter::REST::OAuth do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS")
  end

  describe "#token" do
    before do
      stub_post("/oauth2/token").with(body: {grant_type: "client_credentials"}).to_return(body: fixture("bearer_token.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.token

      assert_requested(a_post("/oauth2/token").with(body: {grant_type: "client_credentials"}, headers: {authorization: "Basic Q0s6Q1M=", content_type: "application/x-www-form-urlencoded", accept: "*/*"}))
    end

    it "returns the bearer token" do
      bearer_token = @client.token

      assert_kind_of(String, bearer_token)
      assert_equal("AAAA%2FAAA%3DAAAAAAAA", bearer_token)
    end

    it "does not mutate the passed options hash" do
      options = {custom: "option"}
      options_copy = options.dup
      stub_post("/oauth2/token").with(body: {grant_type: "client_credentials", custom: "option"}).to_return(body: fixture("bearer_token.json"), headers: json_headers)
      @client.token(options)

      assert_equal(options_copy, options)
      assert_requested(a_post("/oauth2/token").with(body: {grant_type: "client_credentials", custom: "option"}))
    end

    it "builds headers with the post verb and oauth2 token URL" do
      url = "https://api.twitter.com/oauth2/token"
      header_builder = Object.new
      header_builder.define_singleton_method(:request_headers) { {authorization: "Basic custom"} }
      response = Object.new
      response.define_singleton_method(:parse) { {"access_token" => "token-from-http"} }
      http_client = Object.new

      headers_new_called = false
      http_headers_called = false
      post_called = false
      posted_url = nil
      posted_form = nil

      http_client.define_singleton_method(:post) do |post_url, form:|
        post_called = true
        posted_url = post_url
        posted_form = form
        response
      end

      Twitter::Headers.stub(:new, lambda { |client, verb, requested_url, options|
        headers_new_called = true

        assert_operator(client, :equal?, @client)
        assert_equal(:post, verb)
        assert_equal(url, requested_url)
        assert(options[:bearer_token_request])
        assert_equal("client_credentials", options[:grant_type])
        header_builder
      }) do
        HTTP.stub(:headers, lambda { |headers|
          http_headers_called = true

          assert_equal({authorization: "Basic custom"}, headers)
          http_client
        }) do
          assert_equal("token-from-http", @client.token)
        end
      end

      assert(headers_new_called)
      assert(http_headers_called)
      assert(post_called)
      assert_equal(url, posted_url)
      assert(posted_form[:bearer_token_request])
      assert_equal("client_credentials", posted_form[:grant_type])
    end
  end

  describe "#invalidate_token" do
    before do
      stub_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"}).to_return(body: '{"access_token":"AAAA%2FAAA%3DAAAAAAAA"}', headers: json_headers)
      @client.bearer_token = "AAAA%2FAAA%3DAAAAAAAA"
    end

    it "requests the correct resource" do
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")

      assert_requested(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"}))
    end

    it "returns the invalidated token" do
      token = @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")

      assert_kind_of(String, token)
      assert_equal("AAAA%2FAAA%3DAAAAAAAA", token)
    end

    describe "with a token" do
      it "requests the correct resource" do
        token = "AAAA%2FAAA%3DAAAAAAAA"
        @client.invalidate_token(token)

        assert_requested(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"}))
      end
    end

    it "does not mutate the passed options hash" do
      options = {custom: "option"}
      options_copy = options.dup
      stub_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA", custom: "option"}).to_return(body: '{"access_token":"AAAA%2FAAA%3DAAAAAAAA"}', headers: json_headers)
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA", options)

      assert_equal(options_copy, options)
      assert_requested(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA", custom: "option"}))
    end
  end

  describe "#reverse_token" do
    before do
      # WebMock treats Basic Auth differently so we have to check against the full URL with credentials.
      @oauth_request_token_url = "https://api.twitter.com/oauth/request_token?x_auth_mode=reverse_auth"
      stub_request(:post, @oauth_request_token_url).to_return(body: fixture("request_token.txt"), headers: {content_type: "text/html; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.reverse_token

      assert_requested(a_request(:post, @oauth_request_token_url).with(query: {x_auth_mode: "reverse_auth"}))
    end

    it "returns the correct value" do
      assert_equal(fixture("request_token.txt"), @client.reverse_token)
    end

    it "uses oauth_auth_header.to_s as the authorization header" do
      url = "https://api.twitter.com/oauth/request_token"
      options = {x_auth_mode: "reverse_auth"}
      oauth_header = Object.new
      oauth_header.define_singleton_method(:to_s) { "OAuth oauth_consumer_key=\"CK\"" }
      header_builder = Object.new
      header_builder.define_singleton_method(:oauth_auth_header) { oauth_header }
      http_client = Object.new
      response = Object.new
      response.define_singleton_method(:to_s) { "oauth_token=abc" }
      headers_new_called = false
      http_headers_called = false
      post_called = false
      posted_url = nil
      posted_params = nil

      http_client.define_singleton_method(:post) do |post_url, params:|
        post_called = true
        posted_url = post_url
        posted_params = params
        response
      end

      Twitter::Headers.stub(:new, lambda { |client, verb, requested_url, request_options|
        headers_new_called = true

        assert_operator(client, :equal?, @client)
        assert_equal(:post, verb)
        assert_equal(url, requested_url)
        assert_equal(options, request_options)
        header_builder
      }) do
        HTTP.stub(:headers, lambda { |headers|
          http_headers_called = true

          assert_equal({authorization: "OAuth oauth_consumer_key=\"CK\""}, headers)
          http_client
        }) do
          assert_equal("oauth_token=abc", @client.reverse_token)
        end
      end

      assert(headers_new_called)
      assert(http_headers_called)
      assert(post_called)
      assert_equal(url, posted_url)
      assert_equal(options, posted_params)
    end

    it "resolves Headers from the absolute ::Twitter namespace" do
      with_stubbed_const("Twitter::REST::OAuth::Headers", Class.new do
        def self.new(*)
          raise "resolved local Headers constant"
        end
      end) do
        with_stubbed_const("Twitter::REST::OAuth::Twitter", Module.new do
          const_set(:Headers, Class.new do
            def self.new(*)
              raise "resolved local Twitter::Headers constant"
            end
          end)
        end) do
          assert_nothing_raised { @client.reverse_token }
        end
      end
    end
  end

  describe "#token constant resolution" do
    it "resolves Headers from the absolute ::Twitter namespace" do
      stub_post("/oauth2/token").to_return(body: fixture("bearer_token.json"), headers: json_headers)
      with_stubbed_const("Twitter::REST::OAuth::Headers", Class.new do
        def self.new(*)
          raise "resolved local Headers constant"
        end
      end) do
        with_stubbed_const("Twitter::REST::OAuth::Twitter", Module.new do
          const_set(:Headers, Class.new do
            def self.new(*)
              raise "resolved local Twitter::Headers constant"
            end
          end)
        end) do
          assert_nothing_raised { @client.token }
        end
      end
    end
  end
end
