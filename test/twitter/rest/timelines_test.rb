require "test_helper"

describe Twitter::REST::Timelines do
  before do
    @client = build_rest_client
  end

  describe "#mentions_timeline" do
    before do
      stub_get("/1.1/statuses/mentions_timeline.json").to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.mentions_timeline

      assert_requested(a_get("/1.1/statuses/mentions_timeline.json"))
    end

    it "returns the 20 most recent mentions (status containing @username) for the authenticating user" do
      tweets = @client.mentions_timeline

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/mentions_timeline.json").with(query: {since_id: "12345"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.mentions_timeline(since_id: 12_345)

        assert_requested(a_get("/1.1/statuses/mentions_timeline.json").with(query: {since_id: "12345"}))
      end
    end
  end

  describe "#user_timeline" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user_timeline("sferik")

        assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {screen_name: "sferik"}))
      end

      it "returns the 20 most recent Tweets posted by the user specified by screen name or user id" do
        tweets = @client.user_timeline("sferik")

        assert_kind_of(Array, tweets)
        assert_kind_of(Twitter::Tweet, tweets.first)
        assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user_timeline

        assert_requested(a_get("/1.1/statuses/user_timeline.json"))
      end
    end
  end

  describe "#retweeted_by_user" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweeted_by_user("sferik")

      assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200"}))
      assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200", max_id: "244102729860009983"}), times: 3)
    end

    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_user("sferik")

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k", tweets.first.text)
    end

    describe "with count option" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200", since_id: "12345"}).to_return(body: fixture("statuses.json"), headers: json_headers)
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200", since_id: "12345", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "passes options through and respects count" do
        tweets = @client.retweeted_by_user("sferik", count: 5, since_id: 12_345)

        assert_equal(5, tweets.length)
        assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", screen_name: "sferik", count: "200", since_id: "12345"}))
      end
    end
  end

  describe "#retweeted_by_me" do
    before do
      stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweeted_by_me

      assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200"}))
      assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200", max_id: "244102729860009983"}), times: 3)
    end

    it "returns the 20 most recent retweets posted by the authenticating user" do
      tweets = @client.retweeted_by_me

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k", tweets.first.text)
    end

    describe "when no tweets are returned" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200"}).to_return(body: "[]", headers: json_headers)
      end

      it "returns an empty array" do
        tweets = @client.retweeted_by_me

        assert_kind_of(Array, tweets)
        assert_empty(tweets)
      end
    end

    describe "with count option" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345"}).to_return(body: fixture("statuses.json"), headers: json_headers)
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "passes options through and respects count" do
        tweets = @client.retweeted_by_me(count: 5, since_id: 12_345)

        assert_equal(5, tweets.length)
        assert_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345"}))
      end
    end

    describe "with count of 1" do
      before do
        stub_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "returns exactly 1 retweet" do
        tweets = @client.retweeted_by_me(count: 1)

        assert_equal(1, tweets.length)
        assert_kind_of(Twitter::Tweet, tweets.first)
      end
    end

    describe "with count of 0" do
      it "returns an empty array without fetching tweets" do
        tweets = @client.retweeted_by_me(count: 0)

        assert_kind_of(Array, tweets)
        assert_empty(tweets)
        assert_not_requested(a_get("/1.1/statuses/user_timeline.json").with(query: {include_rts: "true", count: "200"}))
      end
    end
  end

  describe "#home_timeline" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.home_timeline

      assert_requested(a_get("/1.1/statuses/home_timeline.json"))
    end

    it "returns the 20 most recent Tweets, including retweets if they exist, posted by the authenticating user and the users they follow" do
      tweets = @client.home_timeline

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
    end
  end

  describe "#retweeted_to_me" do
    before do
      stub_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      stub_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweeted_to_me

      assert_requested(a_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200"}))
      assert_requested(a_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200", max_id: "244102729860009983"}), times: 3)
    end

    it "returns the 20 most recent retweets posted by users the authenticating user follow" do
      tweets = @client.retweeted_to_me

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("RT @olivercameron: Mosaic looks cool: http://t.co/A8013C9k", tweets.first.text)
    end

    describe "with count option" do
      before do
        stub_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345"}).to_return(body: fixture("statuses.json"), headers: json_headers)
        stub_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345", max_id: "244102729860009983"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "passes options through and respects count" do
        tweets = @client.retweeted_to_me(count: 5, since_id: 12_345)

        assert_equal(5, tweets.length)
        assert_requested(a_get("/1.1/statuses/home_timeline.json").with(query: {include_rts: "true", count: "200", since_id: "12345"}))
      end
    end
  end

  describe "#retweets_of_me" do
    before do
      stub_get("/1.1/statuses/retweets_of_me.json").to_return(body: fixture("statuses.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.retweets_of_me

      assert_requested(a_get("/1.1/statuses/retweets_of_me.json"))
    end

    it "returns the 20 most recent tweets of the authenticated user that have been retweeted by others" do
      tweets = @client.retweets_of_me

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
    end

    describe "with options" do
      before do
        stub_get("/1.1/statuses/retweets_of_me.json").with(query: {since_id: "12345"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.retweets_of_me(since_id: 12_345)

        assert_requested(a_get("/1.1/statuses/retweets_of_me.json").with(query: {since_id: "12345"}))
      end
    end
  end
end
