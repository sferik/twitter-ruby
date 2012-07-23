require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#favorites" do
    context "with a screen name passed" do
      before do
        stub_get("/1/favorites/sferik.json").
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.favorites("sferik")
        a_get("/1/favorites/sferik.json").
          should have_been_made
      end
      it "returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites("sferik")
        favorites.should be_an Array
        favorites.first.should be_a Twitter::Status
        favorites.first.user.name.should eq "Zach Brock"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/favorites.json").
          to_return(:body => fixture("favorites.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.favorites
        a_get("/1/favorites.json").
          should have_been_made
      end
      it "returns the 20 most recent favorite statuses for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites
        favorites.should be_an Array
        favorites.first.should be_a Twitter::Status
        favorites.first.user.name.should eq "Zach Brock"
      end
    end
  end

  describe "#favorite" do
    before do
      stub_post("/1/favorites/create/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.favorite(25938088801)
      a_post("/1/favorites/create/25938088801.json").
        should have_been_made
    end
    it "returns an array of favorited statuses" do
      statuses = @client.favorite(25938088801)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#unfavorite" do
    before do
      stub_delete("/1/favorites/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unfavorite(25938088801)
      a_delete("/1/favorites/destroy/25938088801.json").
        should have_been_made
    end
    it "returns an array of un-favorited statuses" do
      statuses = @client.unfavorite(25938088801)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#home_timeline" do
    before do
      stub_get("/1/statuses/home_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.home_timeline
      a_get("/1/statuses/home_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the user's they follow" do
      statuses = @client.home_timeline
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#mentions" do
    before do
      stub_get("/1/statuses/mentions.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.mentions
      a_get("/1/statuses/mentions.json").
        should have_been_made
    end
    it "returns the 20 most recent mentions (status containing @username) for the authenticating user" do
      statuses = @client.mentions
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweeted_by_user" do
    before do
      stub_get("/1/statuses/retweeted_by_user.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_user("sferik")
      a_get("/1/statuses/retweeted_by_user.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      statuses = @client.retweeted_by_user("sferik")
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "retweeted_by_me" do
    before do
      stub_get("/1/statuses/retweeted_by_me.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_by_me
      a_get("/1/statuses/retweeted_by_me.json").
        should have_been_made
    end
    it "returns the 20 most recent retweets posted by the authenticating user" do
      statuses = @client.retweeted_by_me
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweeted_to_user" do
    before do
      stub_get("/1/statuses/retweeted_to_user.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_to_user("sferik")
      a_get("/1/statuses/retweeted_to_user.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns the 20 most recent retweets posted by users the specified user follow" do
      statuses = @client.retweeted_to_user("sferik")
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweeted_to_me" do
    before do
      stub_get("/1/statuses/retweeted_to_me.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeted_to_me
      a_get("/1/statuses/retweeted_to_me.json").
        should have_been_made
    end
    it "returns the 20 most recent retweets posted by users the authenticating user follow" do
      statuses = @client.retweeted_to_me
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweets_of_me" do
    before do
      stub_get("/1/statuses/retweets_of_me.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets_of_me
      a_get("/1/statuses/retweets_of_me.json").
        should have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      statuses = @client.retweets_of_me
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#user_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline("sferik")
        a_get("/1/statuses/user_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent statuses posted by the user specified by screen name or user id" do
        statuses = @client.user_timeline("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/user_timeline.json").
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user_timeline
        a_get("/1/statuses/user_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#media_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline("sferik")
        a_get("/1/statuses/media_timeline.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the 20 most recent images posted by the user specified by screen name or user id" do
        statuses = @client.media_timeline("sferik")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Google is throwing up a question mark for Sunday's weather in Boston. At least they're being honest. http://t.co/Jh7bAhS"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/statuses/media_timeline.json").
          to_return(:body => fixture("media_timeline.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.media_timeline
        a_get("/1/statuses/media_timeline.json").
          should have_been_made
      end
    end
  end

  describe "#network_timeline" do
    before do
      stub_get("/i/statuses/network_timeline.json").
        to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.network_timeline
      a_get("/i/statuses/network_timeline.json").
        should have_been_made
    end
    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      statuses = @client.network_timeline
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end

  describe "#retweeters_of" do
    context "with ids_only passed" do
      before do
        stub_get("/1/statuses/27467028175/retweeted_by/ids.json").
          to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_of(27467028175, :ids_only => true)
        a_get("/1/statuses/27467028175/retweeted_by/ids.json").
          should have_been_made
      end
      it "returns an array of numeric user IDs of retweeters of a status" do
        ids = @client.retweeters_of(27467028175, :ids_only => true)
        ids.should be_an Array
        ids.first.should eq 47
      end
    end
    context "without ids_only passed" do
      before do
        stub_get("/1/statuses/27467028175/retweeted_by.json").
          to_return(:body => fixture("retweeters_of.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_of(27467028175)
        a_get("/1/statuses/27467028175/retweeted_by.json").
          should have_been_made
      end
      it "returns an array of user of retweeters of a status" do
        users = @client.retweeters_of(27467028175)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Dave W Baldwin"
      end
    end
  end

  describe "#retweets" do
    before do
      stub_get("/1/statuses/retweets/28561922516.json").
        to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweets(28561922516)
      a_get("/1/statuses/retweets/28561922516.json").
        should have_been_made
    end
    it "returns up to 100 of the first retweets of a given tweet" do
      statuses = @client.retweets(28561922516)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
    end
  end

  describe "#status" do
    before do
      stub_get("/1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status(25938088801)
      a_get("/1/statuses/show/25938088801.json").
        should have_been_made
    end
    it "returns a status" do
      status = @client.status(25938088801)
      status.should be_a Twitter::Status
      status.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#statuses" do
    before do
      stub_get("/1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.statuses(25938088801)
      a_get("/1/statuses/show/25938088801.json").
        should have_been_made
    end
    it "returns an array of statuses" do
      statuses = @client.statuses(25938088801)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
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
    it "returns a status" do
      status = @client.status_activity(25938088801)
      status.should be_a Twitter::Status
      status.retweeters_count.should eq 1
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
    it "returns an array of statuses" do
      statuses = @client.statuses_activity(25938088801)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.retweeters_count.should eq 1
    end
  end

  describe "#status_destroy" do
    before do
      stub_delete("/1/statuses/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status_destroy(25938088801)
      a_delete("/1/statuses/destroy/25938088801.json").
        should have_been_made
    end
    it "returns an array of statuses" do
      statuses = @client.status_destroy(25938088801)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#retweet" do
    before do
      stub_post("/1/statuses/retweet/28561922516.json").
        to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweet(28561922516)
      a_post("/1/statuses/retweet/28561922516.json").
        should have_been_made
    end
    it "returns an array of tweets with retweet details embedded" do
      statuses = @client.retweet(28561922516)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should eq "As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      statuses.first.retweeted_status.text.should eq "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      statuses.first.retweeted_status.id.should_not == statuses.first.id
    end
  end

  describe "#update" do
    before do
      stub_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      a_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        should have_been_made
    end
    it "returns a single status" do
      status = @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      status.should be_a Twitter::Status
      status.text.should eq "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe "#update_with_media" do
    before do
      stub_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "a gif image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("pbjt.gif"))
        a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
          should have_been_made
      end
      it "returns a single status" do
        status = @client.update_with_media("You always have options", fixture("pbjt.gif"))
        status.should be_a Twitter::Status
        status.text.should include("You always have options")
      end
      it 'returns the media as an entity' do
        status = @client.update_with_media("You always have options", fixture("pbjt.gif"))
        status.media.should be
      end
    end
    context "a jpe image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("wildcomet2.jpe"))
        a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
          should have_been_made
      end
      it 'returns the media as an entity' do
        status = @client.update_with_media("You always have options", fixture("wildcomet2.jpe"))
        status.media.should be
      end
    end
    context "a jpeg image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("me.jpeg"))
        a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
          should have_been_made
      end
      it 'returns the media as an entity' do
        status = @client.update_with_media("You always have options", fixture("me.jpeg"))
        status.media.should be
      end
    end
    context "a png image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("we_concept_bg2.png"))
        a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
          should have_been_made
      end
      it 'returns the media as an entity' do
        status = @client.update_with_media("You always have options", fixture("we_concept_bg2.png"))
        status.media.should be
      end
    end
    context "an IO" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", {:io => StringIO.new, :type => 'gif'})
        a_post("/1/statuses/update_with_media.json", "https://upload.twitter.com").
          should have_been_made
      end
      it 'returns the media as an entity' do
        status = @client.update_with_media("You always have options", {:io => StringIO.new, :type => 'gif'})
        status.media.should be
      end
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembed(25938088801)
      a_get("/1/statuses/oembed.json").
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
      stub_get("/1/statuses/oembed.json").
        with(:query => {:id => "25938088801"}).
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembeds(25938088801)
      a_get("/1/statuses/oembed.json").
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
