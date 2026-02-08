require "test_helper"

describe Twitter::REST::Tweets do
  before do
    @client = build_rest_client
  end

  describe "#retweets" do
    before do
      stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: json_headers)
    end

    describe "with a tweet ID passed" do
      it "requests the correct resource" do
        @client.retweets(540_897_316_908_331_009)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
      end

      it "returns up to 100 of the first retweets of a given tweet" do
        tweets = @client.retweets(540_897_316_908_331_009)

        assert_kind_of(Array, tweets)
        assert_kind_of(Twitter::Tweet, tweets.first)
        assert_equal("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.text)
      end
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}).to_return(body: fixture("retweets.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.retweets(540_897_316_908_331_009, count: 5)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweets(tweet)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweets(tweet)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
      end
    end
  end

  describe "#retweeters_of" do
    describe "with ids_only passed" do
      describe "with a tweet ID passed" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.retweeters_of(540_897_316_908_331_009, ids_only: true)

          assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
        end

        it "returns an array of numeric user IDs of retweeters of a Tweet" do
          ids = @client.retweeters_of(540_897_316_908_331_009, ids_only: true)

          assert_kind_of(Array, ids)
          assert_equal(7_505_382, ids.first)
        end
      end

      describe "with ids_only as false" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: json_headers)
        end

        it "returns users, not ids" do
          users = @client.retweeters_of(540_897_316_908_331_009, ids_only: false)

          assert_kind_of(Array, users)
          assert_kind_of(Twitter::User, users.first)
        end
      end

      describe "with ids_only as nil" do
        before do
          stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: json_headers)
        end

        it "returns users, not ids (nil is falsey)" do
          users = @client.retweeters_of(540_897_316_908_331_009, ids_only: nil)

          assert_kind_of(Array, users)
          assert_kind_of(Twitter::User, users.first)
        end
      end
    end

    describe "without ids_only passed" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").to_return(body: fixture("retweets.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.retweeters_of(540_897_316_908_331_009)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
      end

      it "returns an array of user of retweeters of a Tweet" do
        users = @client.retweeters_of(540_897_316_908_331_009)

        assert_kind_of(Array, users)
        assert_kind_of(Twitter::User, users.first)
        assert_equal(7_505_382, users.first.id)
      end

      describe "with a URI object passed" do
        it "requests the correct resource" do
          tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
          @client.retweeters_of(tweet)

          assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
        end
      end

      describe "with a Tweet passed" do
        it "requests the correct resource" do
          tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
          @client.retweeters_of(tweet)

          assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json"))
        end
      end
    end

    describe "with additional options" do
      before do
        stub_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}).to_return(body: fixture("retweets.json"), headers: json_headers)
      end

      it "passes options to retweets request" do
        @client.retweeters_of(540_897_316_908_331_009, count: 5)

        assert_requested(a_get("/1.1/statuses/retweets/540897316908331009.json").with(query: {count: "5"}))
      end

      it "does not modify the original options hash" do
        options = {count: 5, ids_only: true}
        @client.retweeters_of(540_897_316_908_331_009, options)

        assert_equal({count: 5, ids_only: true}, options)
      end
    end
  end

  describe "#status" do
    before do
      stub_get("/1.1/statuses/show/540897316908331009.json").to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.status(540_897_316_908_331_009)

      assert_requested(a_get("/1.1/statuses/show/540897316908331009.json"))
    end

    it "returns a Tweet" do
      tweet = @client.status(540_897_316_908_331_009)

      assert_kind_of(Twitter::Tweet, tweet)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweet.text)
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/show/540897316908331009.json").with(query: {trim_user: "true"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.status(540_897_316_908_331_009, trim_user: true)

        assert_requested(a_get("/1.1/statuses/show/540897316908331009.json").with(query: {trim_user: "true"}))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.status(tweet)

        assert_requested(a_get("/1.1/statuses/show/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.status(tweet)

        assert_requested(a_get("/1.1/statuses/show/540897316908331009.json"))
      end
    end
  end

  describe "#statuses" do
    before do
      stub_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"}).to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.statuses(540_897_316_908_331_009, 91_151_181_040_201_728)

      assert_requested(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"}))
    end

    it "returns an array of Tweets" do
      tweets = @client.statuses(540_897_316_908_331_009, 91_151_181_040_201_728)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
    end

    describe "with URI objects passed" do
      it "requests the correct resource" do
        @client.statuses(URI.parse("https://twitter.com/sferik/status/540897316908331009"), URI.parse("https://twitter.com/sferik/status/91151181040201728"))

        assert_requested(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"}))
      end
    end

    describe "with Tweets passed" do
      it "requests the correct resource" do
        @client.statuses(Twitter::Tweet.new(id: 540_897_316_908_331_009), Twitter::Tweet.new(id: 91_151_181_040_201_728))

        assert_requested(a_post("/1.1/statuses/lookup.json").with(body: {id: "540897316908331009,91151181040201728"}))
      end
    end
  end

  describe "#destroy_status" do
    before do
      stub_post("/1.1/statuses/destroy/540897316908331009.json").to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.destroy_status(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/statuses/destroy/540897316908331009.json"))
    end

    it "returns an array of Tweets" do
      tweets = @client.destroy_status(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweets.first.text)
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.destroy_status(tweet)

        assert_requested(a_post("/1.1/statuses/destroy/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.destroy_status(tweet)

        assert_requested(a_post("/1.1/statuses/destroy/540897316908331009.json"))
      end
    end
  end

  describe "#update" do
    before do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

      assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}))
    end

    it "returns a Tweet" do
      tweet = @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

      assert_kind_of(Twitter::Tweet, tweet)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweet.text)
    end

    describe "already posted" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(status: 403, body: fixture("already_posted.json"), headers: json_headers)
        stub_get("/1.1/statuses/user_timeline.json").with(query: {count: 1}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "requests the correct resources" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}))
        assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {count: 1}))
      end

      it "returns a Tweet" do
        tweet = @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

        assert_kind_of(Twitter::Tweet, tweet)
        assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweet.text)
      end
    end

    describe "with an in-reply-to status" do
      before do
        @tweet = Twitter::Tweet.new(id: 1)
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status: @tweet)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}))
      end
    end

    describe "with an in-reply-to status ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: 1)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}))
      end
    end

    describe "with a place" do
      before do
        @place = Twitter::Place.new(woeid: "df51dec6f4ee2b2c")
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place: @place)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}))
      end
    end

    describe "with a place ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c")

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}))
      end
    end
  end

  describe "#update!" do
    before do
      stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

      assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES"}))
    end

    it "returns a Tweet" do
      tweet = @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES")

      assert_kind_of(Twitter::Tweet, tweet)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweet.text)
    end

    describe "already posted" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(status: 403, body: fixture("already_posted.json"), headers: json_headers)
      end

      it "raises an DuplicateStatus error" do
        assert_raises(Twitter::Error::DuplicateStatus) { @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES") }
      end
    end

    describe "with an in-reply-to status" do
      before do
        @tweet = Twitter::Tweet.new(id: 1)
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status: @tweet)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}))
      end
    end

    describe "with an in-reply-to status ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: 1)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", in_reply_to_status_id: "1"}))
      end
    end

    describe "with a place" do
      before do
        @place = Twitter::Place.new(woeid: "df51dec6f4ee2b2c")
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place: @place)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}))
      end
    end

    describe "with a place ID" do
      before do
        stub_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}).to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.update!("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c")

        assert_requested(a_post("/1.1/statuses/update.json").with(body: {status: "Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", place_id: "df51dec6f4ee2b2c"}))
      end
    end

    describe "with options modification verification" do
      before do
        stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: json_headers)
      end

      it "does not modify the original options hash" do
        options = {in_reply_to_status: Twitter::Tweet.new(id: 1)}
        @client.update!("Test", options)

        assert_equal({in_reply_to_status: Twitter::Tweet.new(id: 1)}, options)
      end
    end
  end

  describe "#retweet" do
    before do
      stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweet(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.text)
      assert_equal("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.retweeted_tweet.text)
      refute_equal(tweets.first.id, tweets.first.retweeted_tweet.id)
    end

    describe "with options" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.retweet(540_897_316_908_331_009, trim_user: true)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}))
      end
    end

    describe "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.retweet(540_897_316_908_331_009) }
      end
    end

    describe "not found" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.retweet(540_897_316_908_331_009) }
      end
    end

    describe "with mixed success and failure" do
      before do
        stub_post("/1.1/statuses/retweet/111.json").to_return(body: fixture("retweet.json"), headers: json_headers)
        stub_post("/1.1/statuses/retweet/222.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: json_headers)
        stub_post("/1.1/statuses/retweet/333.json").to_return(body: fixture("retweet.json"), headers: json_headers)
      end

      it "returns only successful retweets without nils" do
        tweets = @client.retweet(111, 222, 333)

        assert_kind_of(Array, tweets)
        assert_equal(2, tweets.size)
        assert(tweets.all?(Twitter::Tweet))
        refute_includes(tweets, nil)
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweet(tweet)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweet(tweet)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
      end
    end
  end

  describe "#retweet!" do
    before do
      stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweet!(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.retweet!(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.text)
      assert_equal("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.retweeted_tweet.text)
      refute_equal(tweets.first.id, tweets.first.retweeted_tweet.id)
    end

    describe "with options" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.retweet!(540_897_316_908_331_009, trim_user: true)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json").with(body: {trim_user: "true"}))
      end
    end

    describe "forbidden" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: "{}", headers: json_headers)
      end

      it "raises a Forbidden error" do
        assert_raises(Twitter::Error::Forbidden) { @client.retweet!(540_897_316_908_331_009) }
      end
    end

    describe "already retweeted" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 403, body: fixture("already_retweeted.json"), headers: json_headers)
      end

      it "raises an AlreadyRetweeted error" do
        assert_raises(Twitter::Error::AlreadyRetweeted) { @client.retweet!(540_897_316_908_331_009) }
      end
    end

    describe "not found" do
      before do
        stub_post("/1.1/statuses/retweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "raises a NotFound error" do
        assert_raises(Twitter::Error::NotFound) { @client.retweet!(540_897_316_908_331_009) }
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweet!(tweet)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweet!(tweet)

        assert_requested(a_post("/1.1/statuses/retweet/540897316908331009.json"))
      end
    end
  end

  describe "#update_with_media" do
    before do
      stub_post("/1.1/statuses/update.json").to_return(body: fixture("status.json"), headers: json_headers)
      stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(body: fixture("upload.json"), headers: json_headers)
    end

    describe "with a gif image" do
      it "requests the correct resource" do
        @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", fixture_file("pbjt.gif"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/statuses/update.json"))
      end

      it "returns a Tweet" do
        tweet = @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", fixture_file("pbjt.gif"))

        assert_kind_of(Twitter::Tweet, tweet)
        assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweet.text)
      end

      describe "which size is bigger than 5 megabytes" do
        let(:big_gif) { fixture_file("pbjt.gif") }

        before do
          init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
          append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
          finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
          stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        end

        it "requests the correct resource" do
          File.stub(:size, 7_000_000) do
            @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          end

          assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
          assert_requested(a_post("/1.1/statuses/update.json"))
        end

        it "returns a Tweet" do
          tweet = nil
          File.stub(:size, 7_000_000) do
            tweet = @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          end

          assert_kind_of(Twitter::Tweet, tweet)
          assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweet.text)
        end

        it "sends the correct media_category for gif" do
          File.stub(:size, 7_000_000) do
            @client.update_with_media("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", big_gif)
          end
          request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
            req.body.include?("command=INIT") &&
              req.body.include?("media_type=image%2Fgif") &&
              req.body.include?("media_category=tweet_gif")
          end

          assert_requested(request)
        end
      end
    end

    describe "with a jpe image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture_file("wildcomet2.jpe"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/statuses/update.json"))
      end
    end

    describe "with a jpeg image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture_file("me.jpeg"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/statuses/update.json"))
      end
    end

    describe "with a png image" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", fixture_file("we_concept_bg2.png"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/statuses/update.json"))
      end
    end

    describe "with a mp4 video" do
      it "requests the correct resources" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture_file("1080p.mp4"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
        assert_requested(a_post("/1.1/statuses/update.json"))
      end

      it "sends the correct INIT request parameters" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mp4_file = fixture_file("1080p.mp4")
        @client.update_with_media("You always have options", mp4_file)
        request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=INIT") &&
            req.body.include?("media_type=video%2Fmp4") &&
            req.body.include?("media_category=tweet_video") &&
            req.body.include?("total_bytes=")
        end

        assert_requested(request)
      end

      it "sends the correct APPEND request parameters with segment_index starting at 0" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture_file("1080p.mp4"))
        # Multipart form has different format - verify command, media_id, segment_index, and media key
        request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("name=\"command\"\r\n\r\nAPPEND") &&
            req.body.include?("name=\"media_id\"\r\n\r\n710511363345354753") &&
            req.body.include?("name=\"segment_index\"\r\n\r\n0") &&
            req.body.include?("name=\"media\"")
        end

        assert_requested(request)
      end

      it "sends the correct FINALIZE request parameters" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        @client.update_with_media("You always have options", fixture_file("1080p.mp4"))
        request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=FINALIZE") &&
            req.body.include?("media_id=710511363345354753")
        end

        assert_requested(request)
      end

      describe "when the processing is not finished right after the upload" do
        describe "when it succeeds" do
          it "asks for status until the processing is done" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            pending_status_request = {body: fixture("chunk_upload_status_pending.json"), headers: json_headers}
            completed_status_request = {body: fixture("chunk_upload_status_succeeded.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(pending_status_request, completed_status_request)
            sleep_calls = []
            @client.stub(:sleep, lambda { |seconds|
              sleep_calls << seconds
              seconds
            }) do
              @client.update_with_media("You always have options", fixture_file("1080p.mp4"))
            end

            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
            assert_requested(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753"), times: 2)
            assert_requested(a_post("/1.1/statuses/update.json"))
            assert_equal([5, 10], sleep_calls)
          end
        end

        describe "when it fails" do
          it "raises an error" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            failed_status_request = {body: fixture("chunk_upload_status_failed.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            stub_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753").to_return(failed_status_request)
            sleep_calls = []

            @client.stub(:sleep, lambda { |seconds|
              sleep_calls << seconds
              seconds
            }) do
              assert_raises(Twitter::Error::InvalidMedia) { @client.update_with_media("You always have options", fixture_file("1080p.mp4")) }
            end
            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
            assert_requested(a_request(:get, "https://upload.twitter.com/1.1/media/upload.json?command=STATUS&media_id=710511363345354753"))
            assert_equal([5], sleep_calls)
          end
        end

        describe "when Twitter::Client#timeouts[:upload] is set" do
          before { @client.timeouts = {upload: 0.1} }

          it "raises an error when the finalize step is too slow" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_pending.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            assert_raises(Twitter::Error::TimeoutError) { @client.update_with_media("You always have options", fixture_file("1080p.mp4")) }
            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
          end
        end

        describe "when Twitter::Client#timeouts is set without an upload key" do
          before { @client.timeouts = {other: 10} }

          it "does not raise an error for the timeout" do
            init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
            append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
            finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
            stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
            @client.update_with_media("You always have options", fixture_file("1080p.mp4"))

            assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
          end
        end
      end
    end

    describe "with a Tempfile" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", Tempfile.new("tmp"))

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"))
        assert_requested(a_post("/1.1/statuses/update.json"))
      end
    end

    describe "with multiple images" do
      it "requests the correct resource" do
        @client.update_with_media("You always have options", [fixture_file("me.jpeg"), fixture_file("me.jpeg")])

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 2)
        assert_requested(a_post("/1.1/statuses/update.json"))
      end

      it "sends comma-separated media_ids" do
        # Stub uploads to return different media IDs
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json")
          .to_return(
            {body: '{"media_id": 111}', headers: json_headers},
            {body: '{"media_id": 222}', headers: json_headers}
          )
        stub_post("/1.1/statuses/update.json").with(body: hash_including(media_ids: "111,222")).to_return(body: fixture("status.json"), headers: json_headers)
        @client.update_with_media("Multiple images", [fixture_file("me.jpeg"), fixture_file("me.jpeg")])

        assert_requested(a_post("/1.1/statuses/update.json").with(body: hash_including(media_ids: "111,222")))
      end
    end

    describe "with options" do
      it "does not modify the original options hash" do
        options = {possibly_sensitive: true}
        @client.update_with_media("Test", fixture_file("pbjt.gif"), options)

        assert_equal({possibly_sensitive: true}, options)
      end

      it "passes options to the update request" do
        stub_post("/1.1/statuses/update.json").with(body: hash_including(possibly_sensitive: "true")).to_return(body: fixture("status.json"), headers: json_headers)
        @client.update_with_media("Test", fixture_file("pbjt.gif"), possibly_sensitive: true)

        assert_requested(a_post("/1.1/statuses/update.json").with(body: hash_including(possibly_sensitive: "true")))
      end
    end

    describe "status text verification" do
      it "passes the status text to the update request" do
        stub_post("/1.1/statuses/update.json").with(body: hash_including(status: "My status text")).to_return(body: fixture("status.json"), headers: json_headers)
        @client.update_with_media("My status text", fixture_file("pbjt.gif"))

        assert_requested(a_post("/1.1/statuses/update.json").with(body: hash_including(status: "My status text")))
      end
    end

    describe "with a .mov video file" do
      it "requests the correct resources for chunked upload" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mov_file = Tempfile.new(["test", ".mov"])
        mov_file.write("test video content")
        mov_file.rewind
        @client.update_with_media("Video test", mov_file)

        assert_requested(a_request(:post, "https://upload.twitter.com/1.1/media/upload.json"), times: 3)
        assert_requested(a_post("/1.1/statuses/update.json"))
        mov_file.close
        mov_file.unlink
      end

      it "sends the correct INIT request parameters with quicktime media type" do
        init_request = {body: fixture("chunk_upload_init.json"), headers: json_headers}
        append_request = {body: "", headers: {content_type: "text/html;charset=utf-8"}}
        finalize_request = {body: fixture("chunk_upload_finalize_succeeded.json"), headers: json_headers}
        stub_request(:post, "https://upload.twitter.com/1.1/media/upload.json").to_return(init_request, append_request, finalize_request)
        mov_file = Tempfile.new(["test", ".mov"])
        mov_file.write("test video content")
        mov_file.rewind
        @client.update_with_media("Video test", mov_file)
        request = a_request(:post, "https://upload.twitter.com/1.1/media/upload.json").with do |req|
          req.body.include?("command=INIT") &&
            req.body.include?("media_type=video%2Fquicktime") &&
            req.body.include?("media_category=tweet_video")
        end

        assert_requested(request)
        mov_file.close
        mov_file.unlink
      end
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}).to_return(body: fixture("oembed.json"), headers: json_headers)
      stub_get("/1.1/statuses/oembed.json").with(query: {url: "https://twitter.com/sferik/status/540897316908331009"}).to_return(body: fixture("oembed.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.oembed(540_897_316_908_331_009)

      assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
    end

    it "requests the correct resource when a URL is given" do
      @client.oembed("https://twitter.com/sferik/status/540897316908331009")

      assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
    end

    it "returns an array of OEmbed instances" do
      oembed = @client.oembed(540_897_316_908_331_009)

      assert_kind_of(Twitter::OEmbed, oembed)
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}).to_return(body: fixture("oembed.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.oembed(540_897_316_908_331_009, maxwidth: 300)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}))
      end

      it "does not modify the original options hash" do
        options = {maxwidth: 300}
        @client.oembed(540_897_316_908_331_009, options)

        assert_equal({maxwidth: 300}, options)
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.oembed(tweet)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.oembed(tweet)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
      end
    end
  end

  describe "#oembeds" do
    before do
      stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}).to_return(body: fixture("oembed.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.oembeds(540_897_316_908_331_009)

      assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
    end

    it "requests the correct resource when a URL is given" do
      @client.oembeds("https://twitter.com/sferik/status/540897316908331009")

      assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
    end

    it "returns an array of OEmbed instances" do
      oembeds = @client.oembeds(540_897_316_908_331_009)

      assert_kind_of(Array, oembeds)
      assert_kind_of(Twitter::OEmbed, oembeds.first)
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}).to_return(body: fixture("oembed.json"), headers: json_headers)
      end

      it "passes options to each oembed request" do
        @client.oembeds(540_897_316_908_331_009, maxwidth: 300)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009", maxwidth: "300"}))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.oembeds(tweet)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.oembeds(tweet)

        assert_requested(a_get("/1.1/statuses/oembed.json").with(query: {id: "540897316908331009"}))
      end
    end
  end

  describe "#retweeters_ids" do
    before do
      stub_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweeters_ids(540_897_316_908_331_009)

      assert_requested(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}))
    end

    it "returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter" do
      retweeters_ids = @client.retweeters_ids(540_897_316_908_331_009)

      assert_kind_of(Twitter::Cursor, retweeters_ids)
      assert_equal(20_009_713, retweeters_ids.first)
    end

    describe "with each" do
      before do
        stub_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.retweeters_ids(540_897_316_908_331_009).each {}

        assert_requested(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}))
        assert_requested(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "1305102810874389703"}))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.retweeters_ids(tweet)

        assert_requested(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.retweeters_ids(tweet)

        assert_requested(a_get("/1.1/statuses/retweeters/ids.json").with(query: {id: "540897316908331009", cursor: "-1"}))
      end
    end
  end

  describe "#unretweet" do
    before do
      stub_post("/1.1/statuses/unretweet/540897316908331009.json").to_return(body: fixture("retweet.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unretweet(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/statuses/unretweet/540897316908331009.json"))
    end

    it "returns an array of Tweets with retweet details embedded" do
      tweets = @client.unretweet(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @gruber: As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.text)
      assert_equal("As for the Series, I'm for the Giants. Fuck Texas, fuck Nolan Ryan, fuck George Bush.", tweets.first.retweeted_tweet.text)
      refute_equal(tweets.first.id, tweets.first.retweeted_tweet.id)
    end

    describe "with options" do
      before do
        stub_post("/1.1/statuses/unretweet/540897316908331009.json").with(body: {trim_user: "true"}).to_return(body: fixture("retweet.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.unretweet(540_897_316_908_331_009, trim_user: true)

        assert_requested(a_post("/1.1/statuses/unretweet/540897316908331009.json").with(body: {trim_user: "true"}))
      end
    end

    describe "not found" do
      before do
        stub_post("/1.1/statuses/unretweet/540897316908331009.json").to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.unretweet(540_897_316_908_331_009) }
      end
    end

    describe "with mixed success and failure" do
      before do
        stub_post("/1.1/statuses/unretweet/111.json").to_return(body: fixture("retweet.json"), headers: json_headers)
        stub_post("/1.1/statuses/unretweet/222.json").to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
        stub_post("/1.1/statuses/unretweet/333.json").to_return(body: fixture("retweet.json"), headers: json_headers)
      end

      it "returns only successful unretweets without nils" do
        tweets = @client.unretweet(111, 222, 333)

        assert_kind_of(Array, tweets)
        assert_equal(2, tweets.size)
        assert(tweets.all?(Twitter::Tweet))
        refute_includes(tweets, nil)
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.unretweet(tweet)

        assert_requested(a_post("/1.1/statuses/unretweet/540897316908331009.json"))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.unretweet(tweet)

        assert_requested(a_post("/1.1/statuses/unretweet/540897316908331009.json"))
      end
    end
  end
end
