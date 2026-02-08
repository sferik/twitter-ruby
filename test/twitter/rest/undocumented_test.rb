require "test_helper"

describe Twitter::REST::Undocumented do
  before do
    @client = build_rest_client
  end

  describe "#following_followers_of" do
    describe "with a screen_name passed" do
      before do
        stub_get("/users/following_followers_of.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.following_followers_of("sferik")

        assert_requested(a_get("/users/following_followers_of.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of("sferik")

        assert_kind_of(Twitter::Cursor, following_followers_of)
        assert_kind_of(Twitter::User, following_followers_of.first)
      end

      describe "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(query: {screen_name: "sferik", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.following_followers_of("sferik").each {}

          assert_requested(a_get("/users/following_followers_of.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/users/following_followers_of.json").with(query: {screen_name: "sferik", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.following_followers_of(7_505_382)

        assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.following_followers_of(7_505_382).each {}

          assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.following_followers_of

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of

        assert_kind_of(Twitter::Cursor, following_followers_of)
        assert_kind_of(Twitter::User, following_followers_of.first)
      end

      describe "with each" do
        before do
          stub_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.following_followers_of.each {}

          assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/users/following_followers_of.json").with(query: {user_id: "7505382", cursor: "1322801608223717003"}))
        end
      end
    end
  end

  describe "#tweet_count" do
    before do
      stub_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(query: {url: "http://twitter.com"}).to_return(body: fixture("count.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.tweet_count("http://twitter.com")

      assert_requested(a_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(query: {url: "http://twitter.com"}))
    end

    it "returns a Tweet count" do
      tweet_count = @client.tweet_count("http://twitter.com")

      assert_kind_of(Integer, tweet_count)
      assert_equal(13_845_465, tweet_count)
    end

    it "passes options through to the request" do
      stub_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(query: {url: "http://twitter.com", foo: "bar"}).to_return(body: fixture("count.json"), headers: json_headers)
      @client.tweet_count("http://twitter.com", foo: "bar")

      assert_requested(a_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(query: {url: "http://twitter.com", foo: "bar"}))
    end

    describe "with a URI" do
      it "requests the correct resource" do
        uri = URI.parse("http://twitter.com")
        @client.tweet_count(uri)

        assert_requested(a_request(:get, "https://cdn.api.twitter.com/1/urls/count.json").with(query: {url: "http://twitter.com"}))
      end
    end

    it "uses #to_s for URL-like objects without #to_str" do
      uri_like = Class.new do
        def to_s
          "http://twitter.com"
        end
      end.new
      response = Object.new
      response.define_singleton_method(:parse) { {"count" => 13_845_465} }
      called = false

      HTTP.stub(:get, lambda { |url, params:|
        called = true

        assert_equal("https://cdn.api.twitter.com/1/urls/count.json", url)
        assert_equal({url: "http://twitter.com"}, params)
        response
      }) do
        @client.tweet_count(uri_like)
      end

      assert(called)
    end

    it "uses Hash#[] semantics when reading the parsed count" do
      parsed = Hash.new(7)
      response = Object.new
      response.define_singleton_method(:parse) { parsed }

      HTTP.stub(:get, response) do
        assert_equal(7, @client.tweet_count("http://twitter.com"))
      end
    end
  end
end
