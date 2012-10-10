require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#activity_about_me" do
    before do
      stub_get("/i/activity/about_me.json").to_return(:body => fixture("about_me.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.activity_about_me
      expect(a_get("/i/activity/about_me.json")).to have_been_made
    end
    it "returns activity about me" do
      activity_about_me = @client.activity_about_me
      expect(activity_about_me.first).to be_a Twitter::Action::Mention
    end
  end

  describe "#activity_by_friends" do
    before do
      stub_get("/i/activity/by_friends.json").to_return(:body => fixture("by_friends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.activity_by_friends
      expect(a_get("/i/activity/by_friends.json")).to have_been_made
    end
    it "returns activity by friends" do
      activity_by_friends = @client.activity_by_friends
      expect(activity_by_friends.first).to be_a Twitter::Action::Favorite
    end
  end

end
