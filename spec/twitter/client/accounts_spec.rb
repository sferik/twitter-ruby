require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#rate_limit_status" do
    before do
      stub_get("/1/account/rate_limit_status.json").
        to_return(:body => fixture("rate_limit_status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.rate_limit_status
      a_get("/1/account/rate_limit_status.json").
        should have_been_made
    end
    it "returns the remaining number of API requests available to the requesting user before the API limit is reached" do
      rate_limit_status = @client.rate_limit_status
      rate_limit_status.should be_a Twitter::RateLimitStatus
      rate_limit_status.remaining_hits.should eq 19993
    end
  end

  describe "#verify_credentials" do
    before do
      stub_get("/1/account/verify_credentials.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.verify_credentials
      a_get("/1/account/verify_credentials.json").
        should have_been_made
    end
    it "returns the requesting user" do
      user = @client.verify_credentials
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#end_session" do
    before do
      stub_post("/1/account/end_session.json").
        to_return(:body => fixture("end_session.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.end_session
      a_post("/1/account/end_session.json").
        should have_been_made
    end
    it "returns a null cookie" do
      end_session = @client.end_session
      end_session[:error].should eq "Logged out."
    end
  end

  describe "#update_delivery_device" do
    before do
      stub_post("/1/account/update_delivery_device.json").
        with(:body => {:device => "sms"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_delivery_device("sms")
      a_post("/1/account/update_delivery_device.json").
        with(:body => {:device => "sms"}).
        should have_been_made
    end
    it "returns a user" do
      user = @client.update_delivery_device("sms")
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#update_profile" do
    before do
      stub_post("/1/account/update_profile.json").
        with(:body => {:url => "http://github.com/sferik/"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile(:url => "http://github.com/sferik/")
      a_post("/1/account/update_profile.json").
        with(:body => {:url => "http://github.com/sferik/"}).
        should have_been_made
    end
    it "returns a user" do
      user = @client.update_profile(:url => "http://github.com/sferik/")
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#update_profile_background_image" do
    before do
      stub_post("/1/account/update_profile_background_image.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      a_post("/1/account/update_profile_background_image.json").
        should have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_background_image(fixture("we_concept_bg2.png"))
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#update_profile_colors" do
    before do
      stub_post("/1/account/update_profile_colors.json").
        with(:body => {:profile_background_color => "000000"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_colors(:profile_background_color => "000000")
      a_post("/1/account/update_profile_colors.json").
        with(:body => {:profile_background_color => "000000"}).
        should have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_colors(:profile_background_color => "000000")
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#update_profile_image" do
    before do
      stub_post("/1/account/update_profile_image.json").
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update_profile_image(fixture("me.jpeg"))
      a_post("/1/account/update_profile_image.json").
        should have_been_made
    end
    it "returns a user" do
      user = @client.update_profile_image(fixture("me.jpeg"))
      user.should be_a Twitter::User
      user.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#settings" do
    before do
      stub_get("/1/account/settings.json").
        to_return(:body => fixture("settings.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_post("/1/account/settings.json").
        with(:body => {:trend_location_woeid => "23424803"}).
        to_return(:body => fixture("settings.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource on GET" do
      @client.settings
      a_get("/1/account/settings.json").
        should have_been_made
    end
    it "returns settings" do
      settings = @client.settings
      settings.should be_a Twitter::Settings
      settings.language.should eq 'en'
    end
    it "requests the correct resource on POST" do
      @client.settings(:trend_location_woeid => "23424803")
      a_post("/1/account/settings.json").
        with(:body => {:trend_location_woeid => "23424803"}).
        should have_been_made
    end
    it "returns settings" do
      settings = @client.settings(:trend_location_woeid => "23424803")
      settings.should be_a Twitter::Settings
      settings.language.should eq 'en'
    end
  end

end
