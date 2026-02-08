require "test_helper"

describe Twitter::REST::Client do
  before do
    @client = build_rest_client
  end

  describe "#bearer_token?" do
    it "returns true if the app token is present" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", bearer_token: "BT")

      assert_true(client.bearer_token?)
    end

    it "returns false if the bearer_token is not present" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS")

      assert_false(client.bearer_token?)
    end
  end

  describe "#credentials?" do
    it "returns true if only bearer_token is supplied" do
      client = Twitter::REST::Client.new(bearer_token: "BT")

      assert_predicate(client, :credentials?)
    end

    it "returns true if all OAuth credentials are present" do
      client = build_rest_client

      assert_predicate(client, :credentials?)
    end

    it "returns false if any credentials are missing" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT")

      refute_predicate(client, :credentials?)
    end
  end

  describe "#user_id" do
    it "caches the user ID" do
      stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      client = build_rest_client
      2.times { client.send(:user_id) }

      assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}), times: 1)
    end

    it "does not cache the user ID across clients" do
      stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      build_rest_client.send(:user_id)
      build_rest_client.send(:user_id)

      assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}), times: 2)
    end
  end
end
