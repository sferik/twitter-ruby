require "helper"

describe Twitter::REST::Help do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#languages" do
    before do
      stub_get("/2/help/languages.json").to_return(body: fixture("languages.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.languages
      expect(a_get("/2/help/languages.json")).to have_been_made
    end

    it "returns the list of languages supported by Twitter" do
      languages = @client.languages
      expect(languages).to be_an Array
      expect(languages.first).to be_a Twitter::Language
      expect(languages.first.name).to eq("Portuguese")
    end
  end

  describe "#privacy" do
    before do
      stub_get("/2/help/privacy.json").to_return(body: fixture("privacy.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.privacy
      expect(a_get("/2/help/privacy.json")).to have_been_made
    end

    it "returns the Twitter Privacy Policy" do
      privacy = @client.privacy
      expect(privacy.split.first).to eq("Twitter")
    end
  end

  describe "#tos" do
    before do
      stub_get("/2/help/tos.json").to_return(body: fixture("tos.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.tos
      expect(a_get("/2/help/tos.json")).to have_been_made
    end

    it "returns the Twitter Terms of Service" do
      tos = @client.tos
      expect(tos.split.first).to eq("Terms")
    end
  end
end
