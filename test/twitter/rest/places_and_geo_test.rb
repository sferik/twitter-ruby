require "test_helper"

describe Twitter::REST::PlacesAndGeo do
  before do
    @client = build_rest_client
  end

  describe "#place" do
    before do
      stub_get("/1.1/geo/id/247f43d441defc03.json").to_return(body: fixture("place.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.place("247f43d441defc03")

      assert_requested(a_get("/1.1/geo/id/247f43d441defc03.json"))
    end

    it "returns a place" do
      place = @client.place("247f43d441defc03")

      assert_equal("Twitter HQ", place.name)
    end

    it "passes options through to the request" do
      stub_get("/1.1/geo/id/247f43d441defc03.json").with(query: {accuracy: "10m"}).to_return(body: fixture("place.json"), headers: json_headers)
      @client.place("247f43d441defc03", accuracy: "10m")

      assert_requested(a_get("/1.1/geo/id/247f43d441defc03.json").with(query: {accuracy: "10m"}))
    end
  end

  describe "#reverse_geocode" do
    before do
      stub_get("/1.1/geo/reverse_geocode.json").with(query: {lat: "37.7821120598956", long: "-122.400612831116"}).to_return(body: fixture("places.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.reverse_geocode(lat: "37.7821120598956", long: "-122.400612831116")

      assert_requested(a_get("/1.1/geo/reverse_geocode.json").with(query: {lat: "37.7821120598956", long: "-122.400612831116"}))
    end

    it "returns places" do
      places = @client.reverse_geocode(lat: "37.7821120598956", long: "-122.400612831116")

      assert_kind_of(Twitter::GeoResults, places)
      assert_equal("Bernal Heights", places.first.name)
    end

    it "works without options" do
      stub_get("/1.1/geo/reverse_geocode.json").to_return(body: fixture("places.json"), headers: json_headers)
      assert_nothing_raised { @client.reverse_geocode }
    end
  end

  describe "#geo_search" do
    before do
      stub_get("/1.1/geo/search.json").with(query: {ip: "74.125.19.104"}).to_return(body: fixture("places.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.geo_search(ip: "74.125.19.104")

      assert_requested(a_get("/1.1/geo/search.json").with(query: {ip: "74.125.19.104"}))
    end

    it "returns nearby places" do
      places = @client.geo_search(ip: "74.125.19.104")

      assert_kind_of(Twitter::GeoResults, places)
      assert_equal("Bernal Heights", places.first.name)
    end

    it "works without options" do
      stub_get("/1.1/geo/search.json").to_return(body: fixture("places.json"), headers: json_headers)
      assert_nothing_raised { @client.geo_search }
    end
  end

  describe "#similar_places" do
    before do
      stub_get("/1.1/geo/similar_places.json").with(query: {lat: "37.7821120598956", long: "-122.400612831116", name: "Twitter HQ"}).to_return(body: fixture("places.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.similar_places(lat: "37.7821120598956", long: "-122.400612831116", name: "Twitter HQ")

      assert_requested(a_get("/1.1/geo/similar_places.json").with(query: {lat: "37.7821120598956", long: "-122.400612831116", name: "Twitter HQ"}))
    end

    it "returns similar places" do
      places = @client.similar_places(lat: "37.7821120598956", long: "-122.400612831116", name: "Twitter HQ")

      assert_kind_of(Twitter::GeoResults, places)
      assert_equal("Bernal Heights", places.first.name)
    end

    it "works without options" do
      stub_get("/1.1/geo/similar_places.json").to_return(body: fixture("places.json"), headers: json_headers)
      assert_nothing_raised { @client.similar_places }
    end
  end
end
