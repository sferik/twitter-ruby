require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".retweeters_of" do
    context "with ids_only passed" do
      before do
        stub_get("/1/statuses/27467028175/retweeted_by/ids.json").
          to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.retweeters_of(27467028175, :ids_only => true)
        a_get("/1/statuses/27467028175/retweeted_by/ids.json").
          should have_been_made
      end
      it "should return an array of numeric user IDs of retweeters of a status" do
        ids = @client.retweeters_of(27467028175, :ids_only => true)
        ids.should be_an Array
        ids.first.should == 47
      end
    end
    context "without ids_only passed" do
      before do
        stub_get("/1/statuses/27467028175/retweeted_by.json").
          to_return(:body => fixture("retweeters_of.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.retweeters_of(27467028175)
        a_get("/1/statuses/27467028175/retweeted_by.json").
          should have_been_made
      end
      it "should return an array of user of retweeters of a status" do
        users = @client.retweeters_of(27467028175)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should == "Dave W Baldwin"
      end
    end
  end

  describe ".retweets" do
    before do
      stub_get("/1/statuses/retweets/28561922516.json").
        to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.retweets(28561922516)
      a_get("/1/statuses/retweets/28561922516.json").
        should have_been_made
    end
    it "should return up to 100 of the first retweets of a given tweet" do
      statuses = @client.retweets(28561922516)
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Status
      statuses.first.text.should == "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
    end
  end

  describe ".status" do
    before do
      stub_get("/1/statuses/show/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.status(25938088801)
      a_get("/1/statuses/show/25938088801.json").
        should have_been_made
    end
    it "should return a single status" do
      status = @client.status(25938088801)
      status.should be_a Twitter::Status
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe ".status_destroy" do
    before do
      stub_delete("/1/statuses/destroy/25938088801.json").
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.status_destroy(25938088801)
      a_delete("/1/statuses/destroy/25938088801.json").
        should have_been_made
    end
    it "should return a single status" do
      status = @client.status_destroy(25938088801)
      status.should be_a Twitter::Status
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe ".retweet" do
    before do
      stub_post("/1/statuses/retweet/28561922516.json").
        to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.retweet(28561922516)
      a_post("/1/statuses/retweet/28561922516.json").
        should have_been_made
    end
    it "should return the original Tweet with retweet details embedded" do
      status = @client.retweet(28561922516)
      status.should be_a Twitter::Status
      status.text.should == "As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      status.retweeted_status.text.should == "RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush."
      status.retweeted_status.id.should_not == status.id
    end
  end

  describe ".update" do
    before do
      stub_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      a_post("/1/statuses/update.json").
        with(:body => {:status => "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"}).
        should have_been_made
    end
    it "should return a single status" do
      status = @client.update("@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!")
      status.should be_a Twitter::Status
      status.text.should == "@noradio working on implementing #NewTwitter API methods in the twitter gem. Twurl is making it easy. Thank you!"
    end
  end

  describe ".update_with_media" do
    before do
      stub_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        to_return(:body => fixture("status_with_media.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.update_with_media("You always have options", fixture("me.jpeg"))
      a_post("/1/statuses/update_with_media.json", Twitter.media_endpoint).
        should have_been_made
    end
    it "should return a single status" do
      status = @client.update_with_media("You always have options", fixture("me.jpeg"))
      status.text.should include("You always have options")
    end
    it 'should return the media as an entity' do
      status = @client.update_with_media("You always have options", fixture("me.jpeg"))
      status.media.should be
    end
  end

  describe ".oembed" do
    context "with id passed" do
      before do
        stub_get("/1/statuses/oembed.json?id=25938088801").
          to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.oembed(25938088801)
        a_get("/1/statuses/oembed.json?id=25938088801").
          should have_been_made
      end
      it "should return an OEmbed instance" do
        oembed = @client.oembed(25938088801)
        oembed.should be_a Twitter::OEmbed
      end
    end
    context "with url passed" do
      before do
        stub_get("/1/statuses/oembed.json?url=https%3A%2F%2Ftwitter.com%2F%23!%2Ftwitter%2Fstatus%2F25938088801").
          to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.oembed('https://twitter.com/#!/twitter/status/25938088801')
        a_get("/1/statuses/oembed.json?url=https%3A%2F%2Ftwitter.com%2F%23!%2Ftwitter%2Fstatus%2F25938088801").
          should have_been_made
      end
      it "should return an OEmbed instance" do
        oembed = @client.oembed('https://twitter.com/#!/twitter/status/25938088801')
        oembed.should be_a Twitter::OEmbed
      end
    end

  end

end
