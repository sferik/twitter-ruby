require 'helper'

describe Twitter::REST::API::Tweets do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#retweets" do
    before do
      stub_get("/1.1/statuses/retweets/25938088801.json").to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "with a tweet ID passed" do
      it "requests the correct resource" do
        @client.retweets(25938088801)
        expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
      end
      it "returns up to 100 of the first retweets of a given tweet" do
        tweets = @client.retweets(25938088801)
        expect(tweets).to be_an Array
        expect(tweets.first).to be_a Twitter::Tweet
        expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      end
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.retweets(tweet)
        expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.retweets("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.retweets(tweet)
        expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#retweeters_of" do
    context "with ids_only passed" do
      context "with a tweet ID passed" do
        before do
          stub_get("/1.1/statuses/retweets/25938088801.json").to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.retweeters_of(25938088801, :ids_only => true)
          expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
        end
        it "returns an array of numeric user IDs of retweeters of a Tweet" do
          ids = @client.retweeters_of(25938088801, :ids_only => true)
          expect(ids).to be_an Array
          expect(ids.first).to eq(7505382)
        end
      end
    end
    context "without ids_only passed" do
      before do
        stub_get("/1.1/statuses/retweets/25938088801.json").to_return(:body => fixture("retweets.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_of(25938088801)
        expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
      end
      it "returns an array of user of retweeters of a Tweet" do
        users = @client.retweeters_of(25938088801)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7505382)
      end
      context "with a URI object passed" do
        it "requests the correct resource" do
          tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
          @client.retweeters_of(tweet)
          expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
        end
      end
      context "with a URI string passed" do
        it "requests the correct resource" do
          @client.retweeters_of("https://twitter.com/sferik/status/25938088801")
          expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
        end
      end
      context "with a Tweet passed" do
        it "requests the correct resource" do
          tweet = Twitter::Tweet.new(:id => 25938088801)
          @client.retweeters_of(tweet)
          expect(a_get("/1.1/statuses/retweets/25938088801.json")).to have_been_made
        end
      end
    end
  end

  describe "#status" do
    before do
      stub_get("/1.1/statuses/show/25938088801.json").to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status(25938088801)
      expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.status(25938088801)
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.status(tweet)
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.status("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.status(tweet)
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#statuses" do
    before do
      stub_get("/1.1/statuses/show/25938088801.json").to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.statuses(25938088801)
      expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.statuses(25938088801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.statuses(tweet)
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.statuses("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.statuses(tweet)
        expect(a_get("/1.1/statuses/show/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#status_destroy" do
    before do
      stub_post("/1.1/statuses/destroy/25938088801.json").to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.status_destroy(25938088801)
      expect(a_post("/1.1/statuses/destroy/25938088801.json")).to have_been_made
    end
    it "returns an array of Tweets" do
      tweets = @client.status_destroy(25938088801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.status_destroy(tweet)
        expect(a_post("/1.1/statuses/destroy/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.status_destroy("https://twitter.com/sferik/status/25938088801")
        expect(a_post("/1.1/statuses/destroy/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.status_destroy(tweet)
        expect(a_post("/1.1/statuses/destroy/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#update" do
    before do
      stub_post("/1.1/statuses/update.json").with(:body => {:status => "The problem with your code is that it's doing exactly what you told it to do."}).to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.update("The problem with your code is that it's doing exactly what you told it to do.")
      expect(a_post("/1.1/statuses/update.json").with(:body => {:status => "The problem with your code is that it's doing exactly what you told it to do."})).to have_been_made
    end
    it "returns a Tweet" do
      tweet = @client.update("The problem with your code is that it's doing exactly what you told it to do.")
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
    end
    context "already posted" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(:status => 403, :body => fixture("already_posted.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "raises an AlreadyPosted error" do
        expect{@client.update("The problem with your code is that it's doing exactly what you told it to do.")}.to raise_error Twitter::Error::AlreadyPosted
      end
    end
  end

  describe "#retweet" do
    before do
      stub_post("/1.1/statuses/retweet/25938088801.json").to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweet(25938088801)
      expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
    end
    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet(25938088801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end
    context "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/25938088801.json").to_return(:status => 403, :body => fixture("already_retweeted.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "does not raise an error" do
        expect{@client.retweet(25938088801)}.not_to raise_error
      end
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.retweet(tweet)
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.retweet("https://twitter.com/sferik/status/25938088801")
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.retweet(tweet)
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#retweet!" do
    before do
      stub_post("/1.1/statuses/retweet/25938088801.json").to_return(:body => fixture("retweet.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweet!(25938088801)
      expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
    end
    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet!(25938088801)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end
    context "forbidden" do
      before do
        stub_post("/1.1/statuses/retweet/25938088801.json").to_return(:status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "raises a Forbidden error" do
        expect{@client.retweet!(25938088801)}.to raise_error Twitter::Error::Forbidden
      end
    end
    context "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/25938088801.json").to_return(:status => 403, :body => fixture("already_retweeted.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "raises an AlreadyRetweeted error" do
        expect{@client.retweet!(25938088801)}.to raise_error Twitter::Error::AlreadyRetweeted
      end
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.retweet!(tweet)
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.retweet!("https://twitter.com/sferik/status/25938088801")
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.retweet!(tweet)
        expect(a_post("/1.1/statuses/retweet/25938088801.json")).to have_been_made
      end
    end
  end

  describe "#update_with_media" do
    before do
      stub_post("/1.1/statuses/update_with_media.json").to_return(:body => fixture("status.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    context "a gif image" do
      it "requests the correct resource" do
        @client.update_with_media("The problem with your code is that it's doing exactly what you told it to do.", fixture("pbjt.gif"))
        expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
      end
      it "returns a Tweet" do
        tweet = @client.update_with_media("The problem with your code is that it's doing exactly what you told it to do.", fixture("pbjt.gif"))
        expect(tweet).to be_a Twitter::Tweet
        expect(tweet.text).to eq("The problem with your code is that it's doing exactly what you told it to do.")
      end
    end
    context "a jpe image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("wildcomet2.jpe"))
        expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
      end
    end
    context "a jpeg image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("me.jpeg"))
        expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
      end
    end
    context "a png image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("we_concept_bg2.png"))
        expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
      end
    end
    context "a Tempfile" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", Tempfile.new("tmp"))
        expect(a_post("/1.1/statuses/update_with_media.json")).to have_been_made
      end
    end
    context "already posted" do
      before do
        stub_post("/1.1/statuses/update_with_media.json").to_return(:status => 403, :body => fixture("already_posted.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "raises an AlreadyPosted error" do
        expect{@client.update_with_media("The problem with your code is that it's doing exactly what you told it to do.", fixture("pbjt.gif"))}.to raise_error Twitter::Error::AlreadyPosted
      end
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"}).to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/oembed.json").with(:query => {:url => "https://twitter.com/sferik/status/25938088801"}).to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembed(25938088801)
      expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
    end
    it "requests the correct resource when a URL is given" do
      @client.oembed("https://twitter.com/sferik/status/25938088801")
      expect(a_get("/1.1/statuses/oembed.json").with(:query => {:url => "https://twitter.com/sferik/status/25938088801"}))
    end
    it "returns an array of OEmbed instances" do
      oembed = @client.oembed(25938088801)
      expect(oembed).to be_a Twitter::OEmbed
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.oembed(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.oembed("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.oembed(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
  end

  describe "#oembeds" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"}).to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.oembeds(25938088801)
      expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
    end
    it "requests the correct resource when a URL is given" do
      @client.oembeds("https://twitter.com/sferik/status/25938088801")
      expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
    end
    it "returns an array of OEmbed instances" do
      oembeds = @client.oembeds(25938088801)
      expect(oembeds).to be_an Array
      expect(oembeds.first).to be_a Twitter::OEmbed
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.oembeds(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.oembeds("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.oembeds(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(:query => {:id => "25938088801"})).to have_been_made
      end
    end
  end

  describe "#retweeters_ids" do
    before do
      stub_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.retweeters_ids(25938088801)
      expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"})).to have_been_made
    end
    it "returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter" do
      retweeters_ids = @client.retweeters_ids(25938088801)
      expect(retweeters_ids).to be_a Twitter::Cursor
      expect(retweeters_ids.first).to eq(20009713)
    end
    context "with each" do
      before do
        stub_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.retweeters_ids(25938088801).each{}
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"})).to have_been_made
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "1305102810874389703"})).to have_been_made
      end
    end
    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/25938088801")
        @client.retweeters_ids(tweet)
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"})).to have_been_made
      end
    end
    context "with a URI string passed" do
      it "requests the correct resource" do
        @client.retweeters_ids("https://twitter.com/sferik/status/25938088801")
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"})).to have_been_made
      end
    end
    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(:id => 25938088801)
        @client.retweeters_ids(tweet)
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(:query => {:id => "25938088801", :cursor => "-1"})).to have_been_made
      end
    end
  end

end
