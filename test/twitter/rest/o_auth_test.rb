require "helper"

describe Twitter::REST::OAuth do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS")
  end

  describe "#token" do
    before do
      stub_post("/oauth2/token").with(body: {grant_type: "client_credentials"}).to_return(body: fixture("bearer_token.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.token
      expect(a_post("/oauth2/token").with(body: {grant_type: "client_credentials"}, headers: {authorization: "Basic Q0s6Q1M=", content_type: "application/x-www-form-urlencoded", accept: "*/*"})).to have_been_made
    end

    it "returns the bearer token" do
      bearer_token = @client.token
      expect(bearer_token).to be_a String
      expect(bearer_token).to eq("AAAA%2FAAA%3DAAAAAAAA")
    end

    it "does not mutate the passed options hash" do
      options = {custom: "option"}
      options_copy = options.dup
      stub_post("/oauth2/token").with(body: {grant_type: "client_credentials", custom: "option"}).to_return(body: fixture("bearer_token.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.token(options)
      expect(options).to eq(options_copy)
      expect(a_post("/oauth2/token").with(body: {grant_type: "client_credentials", custom: "option"})).to have_been_made
    end

    it "builds headers with the post verb and oauth2 token URL" do
      url = "https://api.twitter.com/oauth2/token"
      header_builder = instance_double(Twitter::Headers, request_headers: {authorization: "Basic custom"})
      response = instance_double("HTTP::Response", parse: {"access_token" => "token-from-http"})
      http_client = instance_double("HTTP::Client")

      expect(Twitter::Headers).to receive(:new)
        .with(@client, :post, url, hash_including(bearer_token_request: true, grant_type: "client_credentials"))
        .and_return(header_builder)
      expect(HTTP).to receive(:headers).with({authorization: "Basic custom"}).and_return(http_client)
      expect(http_client).to receive(:post).with(url, form: hash_including(bearer_token_request: true, grant_type: "client_credentials")).and_return(response)

      expect(@client.token).to eq("token-from-http")
    end
  end

  describe "#invalidate_token" do
    before do
      stub_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"}).to_return(body: '{"access_token":"AAAA%2FAAA%3DAAAAAAAA"}', headers: {content_type: "application/json; charset=utf-8"})
      @client.bearer_token = "AAAA%2FAAA%3DAAAAAAAA"
    end

    it "requests the correct resource" do
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"})).to have_been_made
    end

    it "returns the invalidated token" do
      token = @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA")
      expect(token).to be_a String
      expect(token).to eq("AAAA%2FAAA%3DAAAAAAAA")
    end

    context "with a token" do
      it "requests the correct resource" do
        token = "AAAA%2FAAA%3DAAAAAAAA"
        @client.invalidate_token(token)
        expect(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA"})).to have_been_made
      end
    end

    it "does not mutate the passed options hash" do
      options = {custom: "option"}
      options_copy = options.dup
      stub_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA", custom: "option"}).to_return(body: '{"access_token":"AAAA%2FAAA%3DAAAAAAAA"}', headers: {content_type: "application/json; charset=utf-8"})
      @client.invalidate_token("AAAA%2FAAA%3DAAAAAAAA", options)
      expect(options).to eq(options_copy)
      expect(a_post("/oauth2/invalidate_token").with(body: {access_token: "AAAA%2FAAA%3DAAAAAAAA", custom: "option"})).to have_been_made
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
      expect(a_request(:post, @oauth_request_token_url).with(query: {x_auth_mode: "reverse_auth"})).to have_been_made
    end

    it "returns the correct value" do
      expect(@client.reverse_token).to eql fixture("request_token.txt").read
    end

    it "uses oauth_auth_header.to_s as the authorization header" do
      url = "https://api.twitter.com/oauth/request_token"
      options = {x_auth_mode: "reverse_auth"}
      oauth_header = instance_double("OAuthHeader", to_s: "OAuth oauth_consumer_key=\"CK\"")
      header_builder = instance_double(Twitter::Headers, oauth_auth_header: oauth_header)
      http_client = instance_double("HTTP::Client")
      response = instance_double("HTTP::Response", to_s: "oauth_token=abc")

      expect(Twitter::Headers).to receive(:new).with(@client, :post, url, options).and_return(header_builder)
      expect(HTTP).to receive(:headers).with(authorization: "OAuth oauth_consumer_key=\"CK\"").and_return(http_client)
      expect(http_client).to receive(:post).with(url, params: options).and_return(response)

      expect(@client.reverse_token).to eq("oauth_token=abc")
    end

    it "resolves Headers from the absolute ::Twitter namespace" do
      stub_const("Twitter::REST::OAuth::Headers", Class.new do
        def self.new(*)
          raise "resolved local Headers constant"
        end
      end)
      stub_const("Twitter::REST::OAuth::Twitter", Module.new do
        const_set(:Headers, Class.new do
          def self.new(*)
            raise "resolved local Twitter::Headers constant"
          end
        end)
      end)

      expect { @client.reverse_token }.not_to raise_error
    end
  end

  describe "#token constant resolution" do
    it "resolves Headers from the absolute ::Twitter namespace" do
      stub_post("/oauth2/token").to_return(body: fixture("bearer_token.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_const("Twitter::REST::OAuth::Headers", Class.new do
        def self.new(*)
          raise "resolved local Headers constant"
        end
      end)
      stub_const("Twitter::REST::OAuth::Twitter", Module.new do
        const_set(:Headers, Class.new do
          def self.new(*)
            raise "resolved local Twitter::Headers constant"
          end
        end)
      end)

      expect { @client.token }.not_to raise_error
    end
  end
end
