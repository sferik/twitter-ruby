require "test_helper"

describe Twitter::Place do
  describe ".new" do
    it "raises an IndexError when id or woeid is not specified" do
      assert_nothing_raised { Twitter::Place.new(id: 1) }
      assert_nothing_raised { Twitter::Place.new(woeid: 1) }
      assert_raises(IndexError) { Twitter::Place.new }
    end
  end

  describe "#eql?" do
    it "returns true when objects WOE IDs are the same" do
      place = Twitter::Place.new(woeid: 1, name: "foo")
      other = Twitter::Place.new(woeid: 1, name: "bar")

      assert_operator(place, :eql?, other)
    end

    it "returns false when objects WOE IDs are different" do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Place.new(woeid: 2)

      refute_operator(place, :eql?, other)
    end

    it "returns false when classes are different" do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Base.new(woeid: 1)

      refute_operator(place, :eql?, other)
    end
  end

  describe "#==" do
    it "returns true when objects WOE IDs are the same" do
      place = Twitter::Place.new(woeid: 1, name: "foo")
      other = Twitter::Place.new(woeid: 1, name: "bar")

      assert_equal(place, other)
    end

    it "returns false when objects WOE IDs are different" do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Place.new(woeid: 2)

      refute_equal(place, other)
    end

    it "returns false when classes are different" do
      place = Twitter::Place.new(woeid: 1)
      other = Twitter::Base.new(woeid: 1)

      refute_equal(place, other)
    end
  end

  describe "#bounding_box" do
    it "returns a Twitter::Geo when bounding_box is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", bounding_box: {type: "Polygon", coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})

      assert_kind_of(Twitter::Geo::Polygon, place.bounding_box)
    end

    it "returns nil when not bounding_box is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.bounding_box)
    end
  end

  describe "#bounding_box?" do
    it "returns true when bounding_box is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", bounding_box: {type: "Polygon", coordinates: [[[-122.40348192, 37.77752898], [-122.387436, 37.77752898], [-122.387436, 37.79448597], [-122.40348192, 37.79448597]]]})

      assert_predicate(place, :bounding_box?)
    end

    it "returns false when bounding_box is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      refute_predicate(place, :bounding_box?)
    end
  end

  describe "#contained_within" do
    it "returns a Twitter::Place when contained_within is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", contained_within: {woeid: "247f43d441defc04"})

      assert_kind_of(Twitter::Place, place.contained_within)
    end

    it "returns nil when not contained_within is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.contained_within)
    end
  end

  describe "#contained_within?" do
    it "returns true when contained_within is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", contained_within: {woeid: "247f43d441defc04"})

      assert_predicate(place, :contained?)
    end

    it "returns false when contained_within is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      refute_predicate(place, :contained?)
    end
  end

  describe "#country_code" do
    it "returns a country code when set with country_code" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", country_code: "US")

      assert_equal("US", place.country_code)
    end

    it "returns a country code when set with countryCode" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", countryCode: "US")

      assert_equal("US", place.country_code)
    end

    it "returns nil when not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.country_code)
    end
  end

  describe "#parent_id" do
    it "returns a parent ID when set with parentid" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", parentid: 1)

      assert_equal(1, place.parent_id)
    end

    it "returns nil when not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.parent_id)
    end
  end

  describe "#place_type" do
    it "returns a place type when set with place_type" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", place_type: "city")

      assert_equal("city", place.place_type)
    end

    it "returns a place type when set with placeType[name]" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", placeType: {name: "Town"})

      assert_equal("Town", place.place_type)
    end

    it "returns nil when not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.place_type)
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", url: "https://api.twitter.com/1.1/geo/id/247f43d441defc03.json")

      assert_kind_of(Addressable::URI, place.uri)
      assert_equal("https://api.twitter.com/1.1/geo/id/247f43d441defc03.json", place.uri.to_s)
    end

    it "returns nil when the url is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      assert_nil(place.uri)
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03", url: "https://api.twitter.com/1.1/geo/id/247f43d441defc03.json")

      assert_predicate(place, :uri?)
    end

    it "returns false when the url is not set" do
      place = Twitter::Place.new(woeid: "247f43d441defc03")

      refute_predicate(place, :uri?)
    end
  end
end
