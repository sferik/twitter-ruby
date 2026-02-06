require "helper"

describe Twitter::REST::Help do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#languages" do
    before do
      stub_get("/1.1/help/languages.json").to_return(body: fixture("languages.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.languages
      expect(a_get("/1.1/help/languages.json")).to have_been_made
    end

    it "returns the list of languages supported by Twitter" do
      languages = @client.languages
      expect(languages).to be_an Array
      expect(languages.first).to be_a Twitter::Language
      expect(languages.first.name).to eq("Portuguese")
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/languages.json").with(query: {foo: "bar"}).to_return(body: fixture("languages.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.languages(foo: "bar")
      expect(a_get("/1.1/help/languages.json").with(query: {foo: "bar"})).to have_been_made
    end
  end

  describe "#privacy" do
    before do
      stub_get("/1.1/help/privacy.json").to_return(body: fixture("privacy.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.privacy
      expect(a_get("/1.1/help/privacy.json")).to have_been_made
    end

    it "returns the Twitter Privacy Policy" do
      privacy = @client.privacy
      expect(privacy.split.first).to eq("Twitter")
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/privacy.json").with(query: {foo: "bar"}).to_return(body: fixture("privacy.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.privacy(foo: "bar")
      expect(a_get("/1.1/help/privacy.json").with(query: {foo: "bar"})).to have_been_made
    end

    it "uses hash defaults when the privacy key is missing" do
      fallback = Hash.new("fallback privacy")
      allow(@client).to receive(:perform_get).with("/1.1/help/privacy.json", {}).and_return(fallback)

      expect(@client.privacy).to eq("fallback privacy")
    end
  end

  describe "#tos" do
    before do
      stub_get("/1.1/help/tos.json").to_return(body: fixture("tos.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.tos
      expect(a_get("/1.1/help/tos.json")).to have_been_made
    end

    it "returns the Twitter Terms of Service" do
      tos = @client.tos
      expect(tos.split.first).to eq("Terms")
    end

    it "passes options through to the request" do
      stub_get("/1.1/help/tos.json").with(query: {foo: "bar"}).to_return(body: fixture("tos.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.tos(foo: "bar")
      expect(a_get("/1.1/help/tos.json").with(query: {foo: "bar"})).to have_been_made
    end

    it "uses hash defaults when the tos key is missing" do
      fallback = Hash.new("fallback tos")
      allow(@client).to receive(:perform_get).with("/1.1/help/tos.json", {}).and_return(fallback)

      expect(@client.tos).to eq("fallback tos")
    end
  end
end
