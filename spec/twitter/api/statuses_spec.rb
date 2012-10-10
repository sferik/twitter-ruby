require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#favorites" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/favorites/list.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.favorites("sferik")
        a_get("/1.1/favorites/list.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites("sferik")
        favorites.should be_an Array
        favorites.first.should be_a Twitter::Tweet
        favorites.first.user.id.should eq 2404341
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/favorites/list.json").
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.favorites
        a_get("/1.1/favorites/list.json").
          should have_been_made
      end
      it "returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites
        favorites.should be_an Array
        favorites.first.should be_a Twitter::Tweet
        favorites.first.user.id.should eq 2404341
      end
    end
  end

  describe "#favorite" do
    before do
      stub_post("/1.1/favorites/create.json").
        with(:body => {:id => "25938088801"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.favorite(25938088801)
      a_post("/1.1/favorites/create.json").
        with(:body => {:id => "25938088801"}).
        should have_been_made
    end
    it "returns an array of favorited Tweets" do
      tweets = @client.favorite(25938088801)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#unfavorite" do
    before do
      stub_post("/1.1/favorites/destroy.json").
        with(:body => {:id => "25938088801"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unfavorite(25938088801)
      a_post("/1.1/favorites/destroy.json").
        with(:body => {:id => "25938088801"}).
        should have_been_made
    end
    it "returns an array of un-favorited Tweets" do
      tweets = @client.unfavorite(25938088801)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#home_timeline" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.home_timeline
      a_get("/1.1/statuses/home_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent Tweets, including retweets if they exist, posted by the authenticating user and the user's they follow" do
      tweets = @client.home_timeline
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "Happy Birthday @imdane. Watch out for those @rally pranksters!"
    end
  end

  describe "#mentions_timeline" do
    before do
      stub_get("/1.1/statuses/mentions_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.mentions_timeline
      a_get("/1.1/statuses/mentions_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent mentions (status containing @username) for the authenticating user" do
      tweets = @client.mentions_timeline
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "Happy Birthday @imdane. Watch out for those @rally pranksters!"
    end
  end

  describe "#retweeted_by_user" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200", :max_id => "244102729860009983"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_user("sferik")
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200"}).
        should have_been_made
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :screen_name => "sferik", :count => "200", :max_id => "244102729860009983"}).
        should have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_user("sferik")
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k"
    end
  end

  describe "#retweeted_by_me" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :count => "200"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_me
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :count => "200"}).
        should have_been_made
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).
        should have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_me
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k"
    end
  end

  describe "#retweeted_to_me" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").
        with(:query => {:include_rts => "true", :count => "200"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/home_timeline.json").
        with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_to_me
      stub_get("/1.1/statuses/home_timeline.json").
        with(:query => {:include_rts => "true", :count => "200"}).
        should have_been_made
      stub_get("/1.1/statuses/home_timeline.json").
        with(:query => {:include_rts => "true", :count => "200", :max_id => "244102729860009983"}).
        should have_been_made.times(3)
    end
    it "returns the 20 most recent retweets posted by users the authenticating user follow" do
      tweets = @client.retweeted_to_me
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k"
    end
  end

  describe "#retweets_of_me" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "false", :count => "200"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "false", :count => "200", :max_id => "244102490646278145"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets_of_me
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "false", :count => "200"}).
        should have_been_made
      a_get("/1.1/statuses/user_timeline.json").
        with(:query => {:include_rts => "false", :count => "200", :max_id => "244102490646278145"}).
        should have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      tweets = @client.retweets_of_me
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k"
    end
  end

  describe "#user_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline("sferik")
        a_get("/1.1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent Tweets posted by the user specified by screen name or user id" do
        tweets = @client.user_timeline("sferik")
        tweets.should be_an Array
        tweets.first.should be_a Twitter::Tweet
        tweets.first.text.should eq "Happy Birthday @imdane. Watch out for those @rally pranksters!"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline
        a_get("/1.1/statuses/user_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#media_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline("sferik")
        a_get("/1.1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent images posted by the user specified by screen name or user id" do
        tweets = @client.media_timeline("sferik")
        tweets.should be_an Array
        tweets.first.should be_a Twitter::Tweet
        tweets.first.text.should eq "Google is throwing up a question mark for Sunday's weather in Boston. At least they're being honest. http://t.co/Jh7bAhS"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/statuses/media_timeline.json").
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline
        a_get("/1.1/statuses/media_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#retweeters_of" do
    context "with ids_only passed" do
      before do
        stub_get("/1.1/statuses/retweets/28561922516.json").
          to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_of(28561922516, :ids_only => true)
        a_get("/1.1/statuses/retweets/28561922516.json").
          should have_been_made
      end
      it "returns an array of numeric user IDs of retweeters of a Tweet" do
        ids = @client.retweeters_of(28561922516, :ids_only => true)
        ids.should be_an Array
        ids.first.should eq 7505382
      end
    end
    context "without ids_only passed" do
      before do
        stub_get("/1.1/statuses/retweets/28561922516.json").
          to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_of(28561922516)
        a_get("/1.1/statuses/retweets/28561922516.json").
          should have_been_made
      end
      it "returns an array of user of retweeters of a Tweet" do
        users = @client.retweeters_of(28561922516)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.id.should eq 7505382
      end
    end
  end

  describe "#retweets" do
    before do
      stub_get("/1.1/statuses/retweets/28561922516.json").
        to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets(28561922516)
      a_get("/1.1/statuses/retweets/28561922516.json").
        should have_been_made
    end
    it "returns up to 100 of the first retweets of a given tweet" do
      tweets = @client.retweets(28561922516)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
    end
  end

  describe "#status" do
    before do
      stub_get("/1.1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status(25938088801)
      a_get("/1.1/statuses/show/25938088801.json").
        should have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.status(25938088801)
      tweet.should be_a Twitter::Tweet
      tweet.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#statuses" do
    before do
      stub_get("/1.1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.statuses(25938088801)
      a_get("/1.1/statuses/show/25938088801.json").
        should have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.statuses(25938088801)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#status_activity" do
    before do
      stub_get("/i/statuses/25938088801/activity/summary.json").
        to_return(:body => fixture("activity_summary.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status_activity(25938088801)
      a_get("/i/statuses/25938088801/activity/summary.json").
        should have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.status_activity(25938088801)
      tweet.should be_a Twitter::Tweet
      tweet.retweeters_count.should eq 1
    end
  end

  describe "#statuses_activity" do
    before do
      stub_get("/i/statuses/25938088801/activity/summary.json").
        to_return(:body => fixture("activity_summary.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.statuses_activity(25938088801)
      a_get("/i/statuses/25938088801/activity/summary.json").
        should have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.statuses_activity(25938088801)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.retweeters_count.should eq 1
    end
  end

  describe "#status_destroy" do
    before do
      stub_post("/1.1/statuses/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status_destroy(25938088801)
      a_post("/1.1/statuses/destroy/25938088801.json").
        should have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.status_destroy(25938088801)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#retweet" do
    before do
      stub_post("/1.1/statuses/retweet/28561922516.json").
        to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweet(28561922516)
      a_post("/1.1/statuses/retweet/28561922516.json").
        should have_been_made
    end
    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet(28561922516)
      tweets.should be_an Array
      tweets.first.should be_a Twitter::Tweet
      tweets.first.text.should eq "As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      tweets.first.retweeted_tweet.text.should eq "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      tweets.first.retweeted_tweet.id.should_not eq tweets.first.id
    end
  end

  describe "#tweet" do
    before do
      stub_post("/1.1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      a_post("/1.1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        should have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      tweet.should be_a Twitter::Tweet
      tweet.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#update_with_media" do
    before do
      stub_post("/1.1/statuses/update_with_media.json").
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "a gif image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("pbjt.gif"))
        a_post("/1.1/statuses/update_with_media.json").
          should have_been_made
      end
      it "returns a Tweet" do
        tweet = @client.update_with_media("You always have options", fixture("pbjt.gif"))
        tweet.should be_a Twitter::Tweet
        tweet.text.should eq "You always have options http://t.co/CBYa7Ri"
      end
    end
    context "a jpe image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("wildcomet2.jpe"))
        a_post("/1.1/statuses/update_with_media.json").
          should have_been_made
      end
    end
    context "a jpeg image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("me.jpeg"))
        a_post("/1.1/statuses/update_with_media.json").
          should have_been_made
      end
    end
    context "a png image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("we_concept_bg2.png"))
        a_post("/1.1/statuses/update_with_media.json").
          should have_been_made
      end
    end
    context "a Tempfile" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", Tempfile.new("tmp"))
        a_post("/1.1/statuses/update_with_media.json").
          should have_been_made
      end
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1.1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembed(25938088801)
      a_get("/1.1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        should have_been_made
    end
    it "returns an array of OEmbed instances" do
      oembed = @client.oembed(25938088801)
      oembed.should be_a Twitter::OEmbed
    end
  end

  describe "#oembeds" do
    before do
      stub_get("/1.1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembeds(25938088801)
      a_get("/1.1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        should have_been_made
    end
    it "returns an array of OEmbed instances" do
      oembeds = @client.oembeds(25938088801)
      oembeds.should be_an Array
      oembeds.first.should be_a Twitter::OEmbed
    end
  end

end
