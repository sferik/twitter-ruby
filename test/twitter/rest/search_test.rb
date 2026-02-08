require "test_helper"

describe Twitter::REST::Search do
  before do
    @client = build_rest_client
  end

  describe "#search" do
    it "does not mutate the options hash passed by the caller" do
      options = {}
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: json_headers)

      @client.search("#freebandnames", options)

      assert_empty(options)
    end

    describe "without count specified" do
      before do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.search("#freebandnames")

        assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}))
      end

      it "returns recent Tweets related to a query with images and videos embedded" do
        search = @client.search("#freebandnames")

        assert_kind_of(Twitter::SearchResults, search)
        assert_kind_of(Twitter::Tweet, search.first)
        assert_equal("@Just_Reboot #FreeBandNames mono surround", search.first.text)
      end
    end

    describe "with count specified" do
      before do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3"}).to_return(body: fixture("search.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.search("#freebandnames", count: 3)

        assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3"}))
      end

      it "returns recent Tweets related to a query with images and videos embedded" do
        search = @client.search("#freebandnames", count: 3)

        assert_kind_of(Twitter::SearchResults, search)
        assert_kind_of(Twitter::Tweet, search.first)
        assert_equal("@Just_Reboot #FreeBandNames mono surround", search.first.text)
      end
    end
  end
end
