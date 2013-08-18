require 'helper'

describe Twitter::REST::API::Help do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#configuration" do
    before do
      stub_get("/1.1/help/configuration.json").to_return(:body => fixture("configuration.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.configuration
      expect(a_get("/1.1/help/configuration.json")).to have_been_made
    end
    it "returns Twitter's current configuration" do
      configuration = @client.configuration
      expect(configuration).to be_a Twitter::Configuration
      expect(configuration.characters_reserved_per_media).to eq(20)
    end
  end

  describe "#languages" do
    before do
      stub_get("/1.1/help/languages.json").to_return(:body => fixture("languages.json"), :headers => {:content_type => "application/json; charset=utf-8"})
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
  end

  describe "#privacy" do
    before do
      stub_get("/1.1/help/privacy.json").to_return(:body => fixture("privacy.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.privacy
      expect(a_get("/1.1/help/privacy.json")).to have_been_made
    end
    it "returns Twitter's Privacy Policy" do
      privacy = @client.privacy
      expect(privacy.split.first).to eq("Twitter")
    end
  end

  describe "#tos" do
    before do
      stub_get("/1.1/help/tos.json").to_return(:body => fixture("tos.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.tos
      expect(a_get("/1.1/help/tos.json")).to have_been_made
    end
    it "returns Twitter's Terms of Service" do
      tos = @client.tos
      expect(tos.split.first).to eq("Terms")
    end
  end

end
