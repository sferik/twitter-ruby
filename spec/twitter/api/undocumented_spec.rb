require 'helper'

describe Twitter::API::Undocumented do

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

  describe "#following_followers_of" do
    context "with a screen_name passed" do
      before do
        stub_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of("sferik")
        expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of("sferik")
        expect(following_followers_of).to be_a Twitter::Cursor
        expect(following_followers_of.users).to be_an Array
        expect(following_followers_of.users.first).to be_a Twitter::User
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of
        expect(following_followers_of).to be_a Twitter::Cursor
        expect(following_followers_of.users).to be_an Array
        expect(following_followers_of.users.first).to be_a Twitter::User
      end
    end
  end

  describe "#status_activity" do
    before do
      stub_get("/i/statuses/25938088801/activity/summary.json").to_return(:body => fixture("activity_summary.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status_activity(25938088801)
      expect(a_get("/i/statuses/25938088801/activity/summary.json")).to have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.status_activity(25938088801)
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.retweeters_count).to eq 1
    end
  end

  describe "#statuses_activity" do
    before do
      stub_get("/i/statuses/25938088801/activity/summary.json").to_return(:body => fixture("activity_summary.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.statuses_activity(25938088801)
      expect(a_get("/i/statuses/25938088801/activity/summary.json")).to have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.statuses_activity(25938088801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.retweeters_count).to eq 1
    end
  end

end
