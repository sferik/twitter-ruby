require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#activity_about_me" do
    before do
      stub_get("/i/activity/about_me.json").
        to_return(:body => fixture("about_me.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.activity_about_me
      a_get("/i/activity/about_me.json").
        should have_been_made
    end
    it "returns activity about me" do
      activity_about_me = @client.activity_about_me
      activity_about_me.first.should be_a Twitter::Action::Mention
    end
  end

  describe "#activity_by_friends" do
    before do
      stub_get("/i/activity/by_friends.json").
        to_return(:body => fixture("by_friends.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.activity_by_friends
      a_get("/i/activity/by_friends.json").
        should have_been_made
    end
    it "returns activity by friends" do
      activity_by_friends = @client.activity_by_friends
      activity_by_friends.first.should be_a Twitter::Action::Favorite
    end
  end

end
