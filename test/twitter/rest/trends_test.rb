require "test_helper"

describe Twitter::REST::Trends do
  before do
    @client = build_rest_client
  end

  describe "#trends" do
    describe "with woeid passed" do
      before do
        stub_get("/1.1/trends/place.json").with(query: {id: "2487956"}).to_return(body: fixture("matching_trends.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.trends(2_487_956)

        assert_requested(a_get("/1.1/trends/place.json").with(query: {id: "2487956"}))
      end

      it "returns the top 10 trending topics for a specific WOEID" do
        matching_trends = @client.trends(2_487_956)

        assert_kind_of(Twitter::TrendResults, matching_trends)
        assert_kind_of(Twitter::Trend, matching_trends.first)
        assert_equal("#sevenwordsaftersex", matching_trends.first.name)
      end

      it "passes options and does not mutate the caller hash" do
        stub_get("/1.1/trends/place.json").with(query: {id: "2487956", exclude: "hashtags"}).to_return(body: fixture("matching_trends.json"), headers: json_headers)
        options = {exclude: "hashtags"}

        @client.trends(2_487_956, options)

        assert_equal({exclude: "hashtags"}, options)
        assert_requested(a_get("/1.1/trends/place.json").with(query: {id: "2487956", exclude: "hashtags"}))
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/trends/place.json").with(query: {id: "1"}).to_return(body: fixture("matching_trends.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.trends

        assert_requested(a_get("/1.1/trends/place.json").with(query: {id: "1"}))
      end
    end
  end

  describe "#trends_available" do
    before do
      stub_get("/1.1/trends/available.json").to_return(body: fixture("locations.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.trends_available

      assert_requested(a_get("/1.1/trends/available.json"))
    end

    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_available

      assert_kind_of(Array, locations)
      assert_kind_of(Twitter::Place, locations.first)
      assert_equal("Ireland", locations.first.name)
    end

    it "passes options through to the request" do
      stub_get("/1.1/trends/available.json").with(query: {foo: "bar"}).to_return(body: fixture("locations.json"), headers: json_headers)
      @client.trends_available(foo: "bar")

      assert_requested(a_get("/1.1/trends/available.json").with(query: {foo: "bar"}))
    end
  end

  describe "#trends_closest" do
    before do
      stub_get("/1.1/trends/closest.json").to_return(body: fixture("locations.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.trends_closest

      assert_requested(a_get("/1.1/trends/closest.json"))
    end

    it "returns the locations that Twitter has trending topic information for" do
      locations = @client.trends_closest

      assert_kind_of(Array, locations)
      assert_kind_of(Twitter::Place, locations.first)
      assert_equal("Ireland", locations.first.name)
    end

    it "passes options through to the request" do
      stub_get("/1.1/trends/closest.json").with(query: {lat: "37.7821", long: "-122.4093"}).to_return(body: fixture("locations.json"), headers: json_headers)
      @client.trends_closest(lat: "37.7821", long: "-122.4093")

      assert_requested(a_get("/1.1/trends/closest.json").with(query: {lat: "37.7821", long: "-122.4093"}))
    end
  end
end
