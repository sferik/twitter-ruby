require "helper"

describe Twitter::REST::Tweets do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
  end

  describe "#retweets" do
    before do
      stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    context "with a tweet ID passed" do
      it "requests the correct resource" do
        @client.retweets(540_897_316_908_331_009)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
      end

      it "returns up to 100 of the first retweets of a given tweet" do
        tweets = @client.retweets(540_897_316_908_331_009)
        expect(tweets).to be_an Array
        expect(tweets.first).to be_a Twitter::Tweet
        expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      end
    end

    context "with options" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}).to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.retweets(540_897_316_908_331_009, count: 5)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"})).to have_been_made
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweets(tweet)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweets(tweet)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
      end
    end
  end

  describe "#retweeters_of" do
    context "with ids_only passed" do
      context "with a tweet ID passed" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
        end

        it "requests the correct resource" do
          @client.retweeters_of(540_897_316_908_331_009, ids_only: true)
          expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
        end

        it "returns an array of numeric user IDs of retweeters of a Tweet" do
          ids = @client.retweeters_of(540_897_316_908_331_009, ids_only: true)
          expect(ids).to be_an Array
          expect(ids.first).to eq(7_505_382)
        end
      end

      context "with ids_only as false" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
        end

        it "returns users, not ids" do
          users = @client.retweeters_of(540_897_316_908_331_009, ids_only: false)
          expect(users).to be_an Array
          expect(users.first).to be_a Twitter::User
        end
      end

      context "with ids_only as nil" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
        end

        it "returns users, not ids (nil is falsey)" do
          users = @client.retweeters_of(540_897_316_908_331_009, ids_only: nil)
          expect(users).to be_an Array
          expect(users.first).to be_a Twitter::User
        end
      end
    end

    context "without ids_only passed" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.retweeters_of(540_897_316_908_331_009)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
      end

      it "returns an array of user of retweeters of a Tweet" do
        users = @client.retweeters_of(540_897_316_908_331_009)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7_505_382)
      end

      context "with a URI object passed" do
        it "requests the correct resource" do
          tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
          @client.retweeters_of(tweet)
          expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
        end
      end

      context "with a Tweet passed" do
        it "requests the correct resource" do
          tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
          @client.retweeters_of(tweet)
          expect(a_get("/1.1/statuses/retweets/540897316908331009.json")).to have_been_made
        end
      end
    end

    context "with additional options" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}).to_return(body: fixture("retweets.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to retweets request" do
        @client.retweeters_of(540_897_316_908_331_009, count: 5)
        expect(a_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"})).to have_been_made
      end

      it "does not modify the original options hash" do
        options = {count: 5, ids_only: true}
        @client.retweeters_of(540_897_316_908_331_009, options)
        expect(options).to eq({count: 5, ids_only: true})
      end
    end
  end

  describe "#status" do
    before do
      stub_get("/1.1/statuses/show/540897316908331009.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.status(540_897_316_908_331_009)
      expect(a_get("/1.1/statuses/show/540897316908331009.json")).to have_been_made
    end

    it "returns a Tweet" do
      tweet = @client.status(540_897_316_908_331_009)
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
    end

    context "with options" do
      before do
        stub_get("/1.1/statuses/show/540897316908331009.json").with(query: {trim_user: "true"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.status(540_897_316_908_331_009, trim_user: true)
        expect(a_get("/1.1/statuses/show/540897316908331009.json").with(query: {trim_user: "true"})).to have_been_made
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.status(tweet)
        expect(a_get("/1.1/statuses/show/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.status(tweet)
        expect(a_get("/1.1/statuses/show/540897316908331009.json")).to have_been_made
      end
    end
  end

  describe "#statuses" do
    before do
      stub_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"}).to_return(body: fixture("statuses.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.statuses(540_897_316_908_331_009, 91_151_181_040_201_728)
      expect(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"})).to have_been_made
    end

    it "returns an array of Tweets" do
      tweets = @client.statuses(540_897_316_908_331_009, 91_151_181_040_201_728)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
    end

    context "with URI objects passed" do
      it "requests the correct resource" do
        @client.statuses(URI.parse("https://twitter.com/sferik/status/540897316908331009"), URI.parse("https://twitter.com/sferik/status/91151181040201728"))
        expect(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"})).to have_been_made
      end
    end

    context "with Tweets passed" do
      it "requests the correct resource" do
        @client.statuses(Twitter::Tweet.new(id: 540_897_316_908_331_009), Twitter::Tweet.new(id: 91_151_181_040_201_728))
        expect(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"})).to have_been_made
      end
    end
  end

  describe "#destroy_status" do
    before do
      stub_post("/1.1/statuses/destroy/540897316908331009.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.destroy_status(540_897_316_908_331_009)
      expect(a_post("/1.1/statuses/destroy/540897316908331009.json")).to have_been_made
    end

    it "returns an array of Tweets" do
      tweets = @client.destroy_status(540_897_316_908_331_009)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.destroy_status(tweet)
        expect(a_post("/1.1/statuses/destroy/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.destroy_status(tweet)
        expect(a_post("/1.1/statuses/destroy/540897316908331009.json")).to have_been_made
      end
    end
  end

  describe "#update" do
    before do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
      expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"})).to have_been_made
    end

    it "returns a Tweet" do
      tweet = @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
    end

    context "already posted" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(status: 403, body: fixture("already_posted.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_get("/1.1/statuses/user_timeline.json").with(query: {count: 1}).to_return(body: fixture("statuses.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resources" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"})).to have_been_made
        expect(a_get("/1.1/statuses/user_timeline.json").with(query: {count: 1})).to have_been_made
      end

      it "returns a Tweet" do
        tweet = @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
        expect(tweet).to be_a Twitter::Tweet
        expect(tweet.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
      end
    end

    context "with an in-reply-to status" do
      before do
        @tweet = Twitter::Tweet.new(id: 1)
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status: @tweet)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"})).to have_been_made
      end
    end

    context "with an in-reply-to status ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: 1)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"})).to have_been_made
      end
    end

    context "with a place" do
      before do
        @place = Twitter::Place.new(woeid: "df51dec6f4ee2b2c")
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place: @place)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"})).to have_been_made
      end
    end

    context "with a place ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c")
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"})).to have_been_made
      end
    end
  end

  describe "#update!" do
    before do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
      expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"})).to have_been_made
    end

    it "returns a Tweet" do
      tweet = @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
      expect(tweet).to be_a Twitter::Tweet
      expect(tweet.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
    end

    context "already posted" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(status: 403, body: fixture("already_posted.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises an DuplicateStatus error" do
        expect { @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES") }.to raise_error(Twitter::Error::DuplicateStatus)
      end
    end

    context "with an in-reply-to status" do
      before do
        @tweet = Twitter::Tweet.new(id: 1)
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status: @tweet)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"})).to have_been_made
      end
    end

    context "with an in-reply-to status ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: 1)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"})).to have_been_made
      end
    end

    context "with a place" do
      before do
        @place = Twitter::Place.new(woeid: "df51dec6f4ee2b2c")
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place: @place)
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"})).to have_been_made
      end
    end

    context "with a place ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c")
        expect(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"})).to have_been_made
      end
    end

    context "with options modification verification" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not modify the original options hash" do
        options = {in_reply_to_status: Twitter::Tweet.new(id: 1)}
        @client.update!("Test", options)
        expect(options).to eq({in_reply_to_status: Twitter::Tweet.new(id: 1)})
      end
    end
  end

  describe "#retweet" do
    before do
      stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.retweet(540_897_316_908_331_009)
      expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet(540_897_316_908_331_009)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end

    context "with options" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.retweet(540_897_316_908_331_009, trim_user: true)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"})).to have_been_made
      end
    end

    context "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not raise an error" do
        expect { @client.retweet(540_897_316_908_331_009) }.not_to raise_error
      end
    end

    context "not found" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not raise an error" do
        expect { @client.retweet(540_897_316_908_331_009) }.not_to raise_error
      end
    end

    context "with mixed success and failure" do
      before do
        stub_post("/1.1/statuses/retweet/111.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/statuses/retweet/222.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/statuses/retweet/333.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns only successful retweets without nils" do
        tweets = @client.retweet(111, 222, 333)
        expect(tweets).to be_an Array
        expect(tweets.size).to eq(2)
        expect(tweets).to all(be_a(Twitter::Tweet))
        expect(tweets).not_to include(nil)
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweet(tweet)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweet(tweet)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
      end
    end
  end

  describe "#retweet!" do
    before do
      stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.retweet!(540_897_316_908_331_009)
      expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet!(540_897_316_908_331_009)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end

    context "with options" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.retweet!(540_897_316_908_331_009, trim_user: true)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"})).to have_been_made
      end
    end

    context "forbidden" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: "{}", headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises a Forbidden error" do
        expect { @client.retweet!(540_897_316_908_331_009) }.to raise_error(Twitter::Error::Forbidden)
      end
    end

    context "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises an AlreadyRetweeted error" do
        expect { @client.retweet!(540_897_316_908_331_009) }.to raise_error(Twitter::Error::AlreadyRetweeted)
      end
    end

    context "not found" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "raises a NotFound error" do
        expect { @client.retweet!(540_897_316_908_331_009) }.to raise_error(Twitter::Error::NotFound)
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweet!(tweet)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweet!(tweet)
        expect(a_post("/1.1/statuses/retweet/540897316908331009.json")).to have_been_made
      end
    end
  end

  describe "#update_with_media" do
    before do
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    context "with a gif image" do
      it "requests the correct resource" do
        @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", fixture("pbjt.gif"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end

      it "returns a Tweet" do
        tweet = @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", fixture("pbjt.gif"))
        expect(tweet).to be_a Twitter::Tweet
        expect(tweet.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
      end

      context "which size is bigger than 5 megabytes" do
        let(:big_gif) { fixture("pbjt.gif") }

        before do
          allow(File).to receive(:size).with(big_gif).and_return(7_000_000)
          init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
          append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
          finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
          stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        end

        it "requests the correct resource" do
          @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
          expect(a_post("/1.1/statuses/update.json")).to have_been_made
        end

        it "returns a Tweet" do
          tweet = @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          expect(tweet).to be_a Twitter::Tweet
          expect(tweet.text).to eq("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")
        end

        it "sends the correct media_category for gif" do
          @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
            req.body.include?("command=INIT") &&
            req.body.include?("media_type=image%2Fgif") &&
            req.body.include?("media_category=tweet_gif")
          end).to have_been_made
        end
      end
    end

    context "with a jpe image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("wildcomet2.jpe"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end
    end

    context "with a jpeg image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("me.jpeg"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end
    end

    context "with a png image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture("we_concept_bg2.png"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end
    end

    context "with a mp4 video" do
      it "requests the correct resources" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture("1080p.mp4"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end

      it "sends the correct INIT request parameters" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mp4_file = fixture("1080p.mp4")
        @client.update_with_media("You always have options", mp4_file)
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=INIT") &&
          req.body.include?("media_type=video%2Fmp4") &&
          req.body.include?("media_category=tweet_video") &&
          req.body.include?("total_bytes=")
        end).to have_been_made
      end

      it "sends the correct APPEND request parameters with segment_index starting at 0" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture("1080p.mp4"))
        # Multipart form has different format - verify command, media_id, segment_index, and media key
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("name=\"command\"\r\n\r\nAPPEND") &&
          req.body.include?("name=\"media_id\"\r\n\r\n710511363345354753") &&
          req.body.include?("name=\"segment_index\"\r\n\r\n0") &&
          req.body.include?("name=\"media\"")
        end).to have_been_made
      end

      it "sends the correct FINALIZE request parameters" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture("1080p.mp4"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=FINALIZE") &&
          req.body.include?("media_id=710511363345354753")
        end).to have_been_made
      end

      context "when the processing is not finished right after the upload" do
        context "when it succeeds" do
          it "asks for status until the processing is done" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            pending_status_request = {body: fixture("chunk_upload_status_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            completed_status_request = {body: fixture("chunk_upload_status_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(pending_status_request, completed_status_request)
            expect_any_instance_of(Twitter::REST::DirectMessages).to receive(:sleep).with(5).and_return(5)
            expect_any_instance_of(Twitter::REST::DirectMessages).to receive(:sleep).with(10).and_return(10)
            @client.update_with_media("You always have options", fixture("1080p.mp4"))
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made.times(2)
            expect(a_post("/1.1/statuses/update.json")).to have_been_made
          end
        end

        context "when it fails" do
          it "raises an error" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            failed_status_request = {body: fixture("chunk_upload_status_failed.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(failed_status_request)
            expect_any_instance_of(Twitter::REST::DirectMessages).to receive(:sleep).with(5).and_return(5)
            expect { @client.update_with_media("You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::InvalidMedia)
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
            expect(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753")).to have_been_made
          end
        end

        context "when Twitter::Client#timeouts[:upload] is set" do
          before { @client.timeouts = {upload: 0.1} }

          it "raises an error when the finalize step is too slow" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            expect { @client.update_with_media("You always have options", fixture("1080p.mp4")) }.to raise_error(Twitter::Error::TimeoutError)
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
          end
        end

        context "when Twitter::Client#timeouts is set without an upload key" do
          before { @client.timeouts = {other: 10} }

          it "does not raise an error for the timeout" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            @client.update_with_media("You always have options", fixture("1080p.mp4"))
            expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
          end
        end
      end
    end

    context "with a Tempfile" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", Tempfile.new("tmp"))
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end
    end

    context "with multiple images" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", [fixture("me.jpeg"), fixture("me.jpeg")])
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(2)
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
      end

      it "sends comma-separated media_ids" do
        # Stub uploads to return different media IDs
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json")
          .to_return(
            {body: '{"media_id": 111}', headers: {content_type: "application/json; charset=utf-8"}},
            {body: '{"media_id": 222}', headers: {content_type: "application/json; charset=utf-8"}}
          )
        stub_post("/1.1/statuses/update.json").with(body: hash_including(media_ids: "111,222")).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.update_with_media("Multiple images", [fixture("me.jpeg"), fixture("me.jpeg")])
        expect(a_post("/1.1/statuses/update.json").with(body: hash_including(media_ids: "111,222"))).to have_been_made
      end
    end

    context "with options" do
      it "does not modify the original options hash" do
        options = {possibly_sensitive: true}
        @client.update_with_media("Test", fixture("pbjt.gif"), options)
        expect(options).to eq({possibly_sensitive: true})
      end

      it "passes options to the update request" do
        stub_post("/1.1/statuses/update.json").with(body: hash_including(possibly_sensitive: "true")).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.update_with_media("Test", fixture("pbjt.gif"), possibly_sensitive: true)
        expect(a_post("/1.1/statuses/update.json").with(body: hash_including(possibly_sensitive: "true"))).to have_been_made
      end
    end

    context "status text verification" do
      it "passes the status text to the update request" do
        stub_post("/1.1/statuses/update.json").with(body: hash_including(status: "My status text")).to_return(body: fixture("status.json"), headers: {content_type: "application/json; charset=utf-8"})
        @client.update_with_media("My status text", fixture("pbjt.gif"))
        expect(a_post("/1.1/statuses/update.json").with(body: hash_including(status: "My status text"))).to have_been_made
      end
    end

    context "with a .mov video file" do
      it "requests the correct resources for chunked upload" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mov_file = Tempfile.new(["test", ".mov"])
        mov_file.write("test video content")
        mov_file.rewind
        @client.update_with_media("Video test", mov_file)
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json")).to have_been_made.times(3)
        expect(a_post("/1.1/statuses/update.json")).to have_been_made
        mov_file.close
        mov_file.unlink
      end

      it "sends the correct INIT request parameters with quicktime media type" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: {content_type: "application/json; charset=utf-8"}}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: {content_type: "application/json; charset=utf-8"}}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mov_file = Tempfile.new(["test", ".mov"])
        mov_file.write("test video content")
        mov_file.rewind
        @client.update_with_media("Video test", mov_file)
        expect(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=INIT") &&
          req.body.include?("media_type=video%2Fquicktime") &&
          req.body.include?("media_category=tweet_video")
        end).to have_been_made
        mov_file.close
        mov_file.unlink
      end
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}).to_return(body: fixture("oembed.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/statuses/oembed.json").with(query: {url: "https://twitter.com/sferik/status/540897316908331009"}).to_return(body: fixture("oembed.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.oembed(540_897_316_908_331_009)
      expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
    end

    it "requests the correct resource when a URL is given" do
      @client.oembed("https://twitter.com/sferik/status/540897316908331009")
      expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
    end

    it "returns an array of OEmbed instances" do
      oembed = @client.oembed(540_897_316_908_331_009)
      expect(oembed).to be_a Twitter::OEmbed
    end

    context "with options" do
      before do
        stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}).to_return(body: fixture("oembed.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.oembed(540_897_316_908_331_009, maxwidth: 300)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"})).to have_been_made
      end

      it "does not modify the original options hash" do
        options = {maxwidth: 300}
        @client.oembed(540_897_316_908_331_009, options)
        expect(options).to eq({maxwidth: 300})
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.oembed(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.oembed(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
      end
    end
  end

  describe "#oembeds" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}).to_return(body: fixture("oembed.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.oembeds(540_897_316_908_331_009)
      expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
    end

    it "requests the correct resource when a URL is given" do
      @client.oembeds("https://twitter.com/sferik/status/540897316908331009")
      expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
    end

    it "returns an array of OEmbed instances" do
      oembeds = @client.oembeds(540_897_316_908_331_009)
      expect(oembeds).to be_an Array
      expect(oembeds.first).to be_a Twitter::OEmbed
    end

    context "with options" do
      before do
        stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}).to_return(body: fixture("oembed.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to each oembed request" do
        @client.oembeds(540_897_316_908_331_009, maxwidth: 300)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"})).to have_been_made
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.oembeds(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.oembeds(tweet)
        expect(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"})).to have_been_made
      end
    end
  end

  describe "#retweeters_ids" do
    before do
      stub_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.retweeters_ids(540_897_316_908_331_009)
      expect(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"})).to have_been_made
    end

    it "returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter" do
      retweeters_ids = @client.retweeters_ids(540_897_316_908_331_009)
      expect(retweeters_ids).to be_a Twitter::Cursor
      expect(retweeters_ids.first).to eq(20_009_713)
    end

    context "with each" do
      before do
        stub_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "requests the correct resource" do
        @client.retweeters_ids(540_897_316_908_331_009).each {}
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"})).to have_been_made
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "1305102810874389703"})).to have_been_made
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweeters_ids(tweet)
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"})).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweeters_ids(tweet)
        expect(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"})).to have_been_made
      end
    end
  end

  describe "#unretweet" do
    before do
      stub_post("/1.1/statuses/unretweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resource" do
      @client.unretweet(540_897_316_908_331_009)
      expect(a_post("/1.1/statuses/unretweet/540897316908331009.json")).to have_been_made
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.unretweet(540_897_316_908_331_009)
      expect(tweets).to be_an Array
      expect(tweets.first).to be_a Twitter::Tweet
      expect(tweets.first.text).to eq("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.text).to eq("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.")
      expect(tweets.first.retweeted_tweet.id).not_to eq(tweets.first.id)
    end

    context "with options" do
      before do
        stub_post("/1.1/statuses/unretweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "passes options to the request" do
        @client.unretweet(540_897_316_908_331_009, trim_user: true)
        expect(a_post("/1.1/statuses/unretweet/540897316908331009.json").with(body: {trim_user: "true"})).to have_been_made
      end
    end

    context "not found" do
      before do
        stub_post("/1.1/statuses/unretweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not raise an error" do
        expect { @client.unretweet(540_897_316_908_331_009) }.not_to raise_error
      end
    end

    context "with mixed success and failure" do
      before do
        stub_post("/1.1/statuses/unretweet/111.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/statuses/unretweet/222.json").to_return(status: 404, body: fixture("not_found.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/statuses/unretweet/333.json").to_return(body: fixture("retweet.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns only successful unretweets without nils" do
        tweets = @client.unretweet(111, 222, 333)
        expect(tweets).to be_an Array
        expect(tweets.size).to eq(2)
        expect(tweets).to all(be_a(Twitter::Tweet))
        expect(tweets).not_to include(nil)
      end
    end

    context "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.unretweet(tweet)
        expect(a_post("/1.1/statuses/unretweet/540897316908331009.json")).to have_been_made
      end
    end

    context "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.unretweet(tweet)
        expect(a_post("/1.1/statuses/unretweet/540897316908331009.json")).to have_been_made
      end
    end
  end
end
