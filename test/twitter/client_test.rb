require "test_helper"

describe Twitter::Client do
  let(:client_instance) { Twitter::Client.new }

  describe "#initialize" do
    it "yields self to the given block" do
      yielded_client = nil
      client = Twitter::Client.new { |c| yielded_client = c }

      assert_operator(client, :equal?, yielded_client)
    end
  end

  describe "#user_agent" do
    it "defaults TwitterRubyGem/version" do
      assert_equal("TwitterRubyGem/#{Twitter::Version}", client_instance.user_agent)
    end

    it "uses Twitter::Version explicitly even if Client::Version exists" do
      with_stubbed_const("Twitter::Client::Version", "MUTANT_VERSION") do
        client = Twitter::Client.new

        assert_equal("TwitterRubyGem/#{Twitter::Version}", client.user_agent)
      end
    end
  end

  describe "#user_agent=" do
    it "overwrites the User-Agent string" do
      client_instance.user_agent = "MyTwitterClient/1.0.0"

      assert_equal("MyTwitterClient/1.0.0", client_instance.user_agent)
    end
  end

  describe "#user_token?" do
    it "returns true if the user token/secret are present" do
      client = Twitter::REST::Client.new(access_token: "AT", access_token_secret: "AS")

      assert_predicate(client, :user_token?)
    end

    it "returns false if the user token/secret are not completely present" do
      client = Twitter::REST::Client.new(access_token: "AT")

      refute_predicate(client, :user_token?)
    end

    it "returns false if any user token/secret is blank" do
      client = Twitter::REST::Client.new(access_token: "", access_token_secret: "AS")

      refute_predicate(client, :user_token?)

      client = Twitter::REST::Client.new(access_token: "AT", access_token_secret: "")

      refute_predicate(client, :user_token?)
    end
  end

  describe "#credentials" do
    it "returns a hash with the correct keys for simple_oauth" do
      client = build_rest_client
      credentials = client.credentials

      assert_operator(credentials, :key?, :consumer_key)
      assert_operator(credentials, :key?, :consumer_secret)
      assert_operator(credentials, :key?, :token)
      assert_operator(credentials, :key?, :token_secret)
      assert_equal("CK", credentials[:consumer_key])
      assert_equal("CS", credentials[:consumer_secret])
      assert_equal("AT", credentials[:token])
      assert_equal("AS", credentials[:token_secret])
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = build_rest_client

      assert_predicate(client, :credentials?)
    end

    it "returns false if any credentials are missing" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT")

      refute_predicate(client, :credentials?)
    end

    it "returns false if any credential is blank" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "")

      refute_predicate(client, :credentials?)
    end
  end

  describe "#blank_string? (private)" do
    it "returns false for truthy objects that do not implement #empty?" do
      client = Twitter::Client.new
      value = Object.new

      refute(client.send(:blank_string?, value))
    end
  end
end
