require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#verify_credentials" do
    before do
      stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.verify_credentials
      expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
    end
    it "returns the requesting user" do
      user = @client.verify_credentials
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_delivery_device" do
    before do
      stub_post("/1.1/account/update_delivery_device.json").with(:body => {:device => "sms"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_delivery_device("sms")
      expect(a_post("/1.1/account/update_delivery_device.json").with(:body => {:device => "sms"})).to have_been_made
    end
    it "returns a user" do
      user = @client.update_delivery_device("sms")
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_profile" do
    before do
      stub_post("/1.1/account/update_profile.json").with(:body => {:url => "http://github.com/sferik/"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile(:url => "http://github.com/sferik/")
      expect(a_post("/1.1/account/update_profile.json").with(:body => {:url => "http://github.com/sferik/"})).to have_been_made
    end
    it "returns a user" do
      user = @client.update_profile(:url => "http://github.com/sferik/")
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_profile_background_image" do
    before do
      stub_post("/1.1/account/update_profile_background_image.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      expect(a_post("/1.1/account/update_profile_background_image.json")).to have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_profile_colors" do
    before do
      stub_post("/1.1/account/update_profile_colors.json").with(:body => {:profile_background_color => "000000"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_colors(:profile_background_color => "000000")
      expect(a_post("/1.1/account/update_profile_colors.json").with(:body => {:profile_background_color => "000000"})).to have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_colors(:profile_background_color => "000000")
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_profile_image" do
    before do
      stub_post("/1.1/account/update_profile_image.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_image(fixture("me.jpeg"))
      expect(a_post("/1.1/account/update_profile_image.json")).to have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_image(fixture("me.jpeg"))
      expect(user).to be_a Twitter::User
      expect(user.id).to eq 7505382
    end
  end

  describe "#update_profile_banner" do
    before do
      stub_post("/1.1/account/update_profile_banner.json").to_return(:body => fixture("empty.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_banner(fixture("me.jpeg"))
      expect(a_post("/1.1/account/update_profile_banner.json")).to have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_banner(fixture("me.jpeg"))
      expect(user).to be_nil
    end
  end

  describe "#remove_profile_banner" do
    before do
      stub_post("/1.1/account/remove_profile_banner.json").to_return(:body => fixture("empty.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.remove_profile_banner
      expect(a_post("/1.1/account/remove_profile_banner.json")).to have_been_made
    end
    it "returns a user" do
      user = @client.remove_profile_banner
      expect(user).to be_nil
    end
  end

  describe "#settings" do
    before do
      stub_get("/1.1/account/settings.json").to_return(:body => fixture("settings.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1.1/account/settings.json").with(:body => {:trend_location_woeid => "23424803"}).to_return(:body => fixture("settings.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource on GET" do
      @client.settings
      expect(a_get("/1.1/account/settings.json")).to have_been_made
    end
    it "returns settings" do
      settings = @client.settings
      expect(settings).to be_a Twitter::Settings
      expect(settings.language).to eq 'en'
    end
    it "requests the correct resource on POST" do
      @client.settings(:trend_location_woeid => "23424803")
      expect(a_post("/1.1/account/settings.json").with(:body => {:trend_location_woeid => "23424803"})).to have_been_made
    end
    it "returns settings" do
      settings = @client.settings(:trend_location_woeid => "23424803")
      expect(settings).to be_a Twitter::Settings
      expect(settings.language).to eq 'en'
    end
  end

end
