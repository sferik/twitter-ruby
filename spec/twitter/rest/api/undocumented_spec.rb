require 'helper'

describe Twitter::REST::API::Undocumented do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
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
        expect(following_followers_of.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :screen_name => "sferik"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.following_followers_of("sferik").each{}
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :user_id => "7505382"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of(7505382)
        expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :user_id => "7505382"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.following_followers_of(7505382).each{}
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :user_id => "7505382"})).to have_been_made
        end
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
        expect(following_followers_of.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :screen_name => "sferik"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.following_followers_of.each{}
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "1322801608223717003", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
  end

  describe "#tweet_count" do
    before do
      stub_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(:query => {:url => "http://twitter.com"}).to_return(:body => fixture("count.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.tweet_count("http://twitter.com")
      expect(a_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(:query => {:url => "http://twitter.com"})).to have_been_made
    end
    it "returns a Tweet count" do
      tweet_count = @client.tweet_count("http://twitter.com")
      expect(tweet_count).to be_an Integer
      expect(tweet_count).to eq(13845465)
    end
    context "with a URI" do
      it "requests the correct resource" do
        uri = URI.parse("http://twitter.com")
        @client.tweet_count(uri)
        expect(a_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(:query => {:url => "http://twitter.com"})).to have_been_made
      end
    end
  end

end
