require 'helper'

describe Twitter::REST::API::Timelines do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#mentions_timeline" do
    before do
      stub_get("/1.1/statuses/mentions_timeline.json").to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.mentions_timeline
      expect(a_get("/1.1/statuses/mentions_timeline.json")).to have_been_made
    end
    it "returns the 20 most recent mentions (status containing @username) for the authenticating user" do
      tweets = @client.mentions_timeline
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
    end
  end

  describe "#user_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline("sferik")
        expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns the 20 most recent Tweets posted by the user specified by screen name or user id" do
        tweets = @client.user_timeline("sferik")
        expect(tweets).to be_an Array
        expect(tweets.first).to be_a Twitter::Tweet
        expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline
        expect(a_get("/1.1/statuses/user_timeline.json")).to have_been_made
      end
    end
  end

  describe "#retweeted_by_user" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200", :max_id => "244102729860009983"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_user("sferik")
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200"})).to have_been_made
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200", :max_id => "244102729860009983"})).to have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_user("sferik")
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k")
    end
  end

  describe "#retweeted_by_me" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :count => "200"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_me
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :count => "200"})).to have_been_made
      expect(a_get("/1.1/statuses/user_timeline.json").with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"})).to have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_me
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k")
    end
  end

  describe "#home_timeline" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.home_timeline
      expect(a_get("/1.1/statuses/home_timeline.json")).to have_been_made
    end
    it "returns the 20 most recent Tweets, including retweets if they exist, posted by the authenticating user and the user's they follow" do
      tweets = @client.home_timeline
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
    end
  end

  describe "#retweeted_to_me" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").with(:query => {:include_rts => "true", :count => "200"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/home_timeline.json").with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_to_me
      expect(stub_get("/1.1/statuses/home_timeline.json").with(:query => {:include_rts => "true", :count => "200"})).to have_been_made
      expect(stub_get("/1.1/statuses/home_timeline.json").with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"})).to have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by users the authenticating user follow" do
      tweets = @client.retweeted_to_me
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k")
    end
  end

  describe "#retweets_of_me" do
    before do
      stub_get("/1.1/statuses/retweets_of_me.json").to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets_of_me
      expect(a_get("/1.1/statuses/retweets_of_me.json")).to have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      tweets = @client.retweets_of_me
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
    end
  end

end
