require "test_helper"

describe Twitter::REST::Favorites do
  before do
    @client = build_rest_client
  end

  describe "#favorites" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/favorites/list.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("user_timeline.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.favorites("sferik")

        assert_requested(a_get("/1.1/favorites/list.json").with(query: {screen_name: "sferik"}))
      end

      it "returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites("sferik")

        assert_kind_of(Array, favorites)
        assert_kind_of(Twitter::Tweet, favorites.first)
        assert_equal(7_505_382, favorites.first.user.id)
      end

      describe "with a URI object passed" do
        it "requests the correct resource" do
          user = URI.parse("https://twitter.com/sferik")
          @client.favorites(user)

          assert_requested(a_get("/1.1/favorites/list.json").with(query: {screen_name: "sferik"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/favorites/list.json").to_return(body: fixture("user_timeline.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.favorites

        assert_requested(a_get("/1.1/favorites/list.json"))
      end

      it "returns the 20 most recent favorite Tweets for the authenticating user or user specified by the ID parameter" do
        favorites = @client.favorites

        assert_kind_of(Array, favorites)
        assert_kind_of(Twitter::Tweet, favorites.first)
        assert_equal(7_505_382, favorites.first.user.id)
      end

      it "does not attempt to merge a user when no user argument is given" do
        @client.stub(:merge_user!, lambda {
          flunk("expected #merge_user! not to be called when no user argument is given")
        }) do
          @client.favorites
        end
      end
    end
  end

  describe "#unfavorite" do
    before do
      stub_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unfavorite(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
    end

    it "returns an array of un-favorited Tweets" do
      tweets = @client.unfavorite(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweets.first.text)
    end

    describe "not found" do
      before do
        stub_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}).to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.unfavorite(540_897_316_908_331_009) }
      end

      it "returns an empty array instead of nil entries" do
        assert_empty(@client.unfavorite(540_897_316_908_331_009))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.unfavorite(tweet)

        assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.unfavorite(tweet)

        assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
      end
    end
  end

  describe "#unfavorite!" do
    before do
      stub_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unfavorite!(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
    end

    it "returns an array of un-favorited Tweets" do
      tweets = @client.unfavorite!(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweets.first.text)
    end

    describe "does not exist" do
      before do
        stub_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}).to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "raises a NotFound error" do
        assert_raises(Twitter::Error::NotFound) { @client.unfavorite!(540_897_316_908_331_009) }
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.unfavorite!(tweet)

        assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.unfavorite!(tweet)

        assert_requested(a_post("/1.1/favorites/destroy.json").with(body: {id: "540897316908331009"}))
      end
    end
  end

  describe "#favorite" do
    before do
      stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.favorite(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
    end

    it "returns an array of favorited Tweets" do
      tweets = @client.favorite(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweets.first.text)
    end

    describe "already favorited" do
      before do
        stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(status: 403, body: fixture("already_favorited.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.favorite(540_897_316_908_331_009) }
      end

      it "returns an empty array instead of nil entries" do
        assert_empty(@client.favorite(540_897_316_908_331_009))
      end
    end

    describe "not found" do
      before do
        stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "does not raise an error" do
        assert_nothing_raised { @client.favorite(540_897_316_908_331_009) }
      end

      it "returns an empty array instead of nil entries" do
        assert_empty(@client.favorite(540_897_316_908_331_009))
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.favorite(tweet)

        assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.favorite(tweet)

        assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
      end
    end
  end

  describe "#favorite!" do
    before do
      stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(body: fixture("status.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.favorite!(540_897_316_908_331_009)

      assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
    end

    it "returns an array of favorited Tweets" do
      tweets = @client.favorite!(540_897_316_908_331_009)

      assert_kind_of(Array, tweets)
      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_equal("Powerful cartoon by @BillBramhall: http://t.co/IOEbc5QoES", tweets.first.text)
    end

    describe "forbidden" do
      before do
        stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(status: 403, body: "{}", headers: json_headers)
      end

      it "raises a Forbidden error" do
        assert_raises(Twitter::Error::Forbidden) { @client.favorite!(540_897_316_908_331_009) }
      end
    end

    describe "already favorited" do
      before do
        stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(status: 403, body: fixture("already_favorited.json"), headers: json_headers)
      end

      it "raises an AlreadyFavorited error" do
        assert_raises(Twitter::Error::AlreadyFavorited) { @client.favorite!(540_897_316_908_331_009) }
      end
    end

    describe "does not exist" do
      before do
        stub_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}).to_return(status: 404, body: fixture("not_found.json"), headers: json_headers)
      end

      it "raises a NotFound error" do
        assert_raises(Twitter::Error::NotFound) { @client.favorite!(540_897_316_908_331_009) }
      end
    end

    describe "with a URI object passed" do
      it "requests the correct resource" do
        tweet = URI.parse("https://twitter.com/sferik/status/540897316908331009")
        @client.favorite!(tweet)

        assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
      end
    end

    describe "with a Tweet passed" do
      it "requests the correct resource" do
        tweet = Twitter::Tweet.new(id: 540_897_316_908_331_009)
        @client.favorite!(tweet)

        assert_requested(a_post("/1.1/favorites/create.json").with(body: {id: "540897316908331009"}))
      end
    end
  end
end
