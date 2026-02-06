require "helper"

describe Twitter::Client do
  describe "#initialize" do
    it "yields self to the given block" do
      yielded_client = nil
      client = described_class.new { |c| yielded_client = c }
      expect(yielded_client).to be(client)
    end
  end

  describe "#user_agent" do
    it "defaults TwitterRubyGem/version" do
      expect(subject.user_agent).to eq("TwitterRubyGem/#{Twitter::Version}")
    end

    it "uses Twitter::Version explicitly even if Client::Version exists" do
      stub_const("Twitter::Client::Version", "MUTANT_VERSION")
      client = described_class.new

      expect(client.user_agent).to eq("TwitterRubyGem/#{Twitter::Version}")
    end
  end

  describe "#user_agent=" do
    it "overwrites the User-Agent string" do
      subject.user_agent = "MyTwitterClient/1.0.0"
      expect(subject.user_agent).to eq("MyTwitterClient/1.0.0")
    end
  end

  describe "#user_token?" do
    it "returns true if the user token/secret are present" do
      client = Twitter::REST::Client.new(access_token: "AT", access_token_secret: "AS")
      expect(client.user_token?).to be true
    end

    it "returns false if the user token/secret are not completely present" do
      client = Twitter::REST::Client.new(access_token: "AT")
      expect(client.user_token?).to be false
    end

    it "returns false if any user token/secret is blank" do
      client = Twitter::REST::Client.new(access_token: "", access_token_secret: "AS")
      expect(client.user_token?).to be false

      client = Twitter::REST::Client.new(access_token: "AT", access_token_secret: "")
      expect(client.user_token?).to be false
    end
  end

  describe "#credentials" do
    it "returns a hash with the correct keys for simple_oauth" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      credentials = client.credentials
      expect(credentials).to have_key(:consumer_key)
      expect(credentials).to have_key(:consumer_secret)
      expect(credentials).to have_key(:token)
      expect(credentials).to have_key(:token_secret)
      expect(credentials[:consumer_key]).to eq("CK")
      expect(credentials[:consumer_secret]).to eq("CS")
      expect(credentials[:token]).to eq("AT")
      expect(credentials[:token_secret]).to eq("AS")
    end
  end

  describe "#credentials?" do
    it "returns true if all credentials are present" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      expect(client.credentials?).to be true
    end

    it "returns false if any credentials are missing" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT")
      expect(client.credentials?).to be false
    end

    it "returns false if any credential is blank" do
      client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "")
      expect(client.credentials?).to be false
    end
  end

  describe "#blank_string? (private)" do
    it "returns false for truthy objects that do not implement #empty?" do
      client = described_class.new
      value = Object.new

      expect(client.send(:blank_string?, value)).to be(false)
    end
  end
end
