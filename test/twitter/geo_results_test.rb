require "test_helper"

describe Twitter::GeoResults do
  describe "#each" do
    before do
      @geo_results = Twitter::GeoResults.new(result: {places: [{id: 1}, {id: 2}, {id: 3}, {id: 4}, {id: 5}, {id: 6}]})
    end

    it "iterates" do
      count = 0
      @geo_results.each { count += 1 }

      assert_equal(6, count)
    end

    it "wraps each place as a Twitter::Place object" do
      first_place = @geo_results.first

      assert_kind_of(Twitter::Place, first_place)
      assert_equal(1, first_place.id)
    end

    describe "with start" do
      it "iterates" do
        count = 0
        @geo_results.each(5) { count += 1 }

        assert_equal(1, count)
      end
    end
  end

  describe "#initialize" do
    it "supports being initialized without attrs" do
      geo_results = Twitter::GeoResults.new

      assert_empty(geo_results.attrs)
      assert_empty(geo_results.to_a)
    end

    it "treats nil attrs as an empty hash" do
      geo_results = Twitter::GeoResults.new(nil)

      assert_empty(geo_results.attrs)
      assert_empty(geo_results.to_a)
    end
  end

  describe "#token" do
    it "returns a String when token is set" do
      geo_results = Twitter::GeoResults.new(result: {}, token: "abc123")

      assert_kind_of(String, geo_results.token)
      assert_equal("abc123", geo_results.token)
    end

    it "returns nil when token is not set" do
      geo_results = Twitter::GeoResults.new(result: {})

      assert_nil(geo_results.token)
    end
  end

  describe "#reached_limit? (private)" do
    it "returns false as a strict boolean" do
      geo_results = Twitter::GeoResults.new(result: {})

      refute(geo_results.send(:reached_limit?))
    end
  end
end
