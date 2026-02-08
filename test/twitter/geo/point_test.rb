require "test_helper"

describe Twitter::Geo::Point do
  before do
    @point = Twitter::Geo::Point.new(coordinates: [-122.399983, 37.788299])
  end

  describe "#==" do
    it "returns true for empty objects" do
      point = Twitter::Geo::Point.new
      other = Twitter::Geo::Point.new

      assert_equal(point, other)
    end

    it "returns true when objects coordinates are the same" do
      other = Twitter::Geo::Point.new(coordinates: [-122.399983, 37.788299])

      assert_equal(@point, other)
    end

    it "returns false when objects coordinates are different" do
      other = Twitter::Geo::Point.new(coordinates: [37.788299, -122.399983])

      refute_equal(@point, other)
    end

    it "returns false when classes are different" do
      other = Twitter::Geo.new(coordinates: [-122.399983, 37.788299])

      refute_equal(@point, other)
    end
  end

  describe "#latitude" do
    it "returns the latitude" do
      assert_in_delta(-122.399983, @point.latitude)
    end

    it "returns nil when the latitude index is missing" do
      point = Twitter::Geo::Point.new(coordinates: [])

      assert_nil(point.latitude)
    end

    it "uses index access for coordinate containers that do not implement #at" do
      coordinates = Class.new do
        def [](index)
          {0 => -122.399983, 1 => 37.788299}[index]
        end

        def fetch(_index)
          raise "fetch should not be called"
        end
      end.new
      point = Twitter::Geo::Point.new(coordinates:)

      assert_in_delta(-122.399983, point.latitude)
    end
  end

  describe "#longitude" do
    it "returns the longitude" do
      assert_in_delta(37.788299, @point.longitude)
    end

    it "returns nil when the longitude index is missing" do
      point = Twitter::Geo::Point.new(coordinates: [-122.399983])

      assert_nil(point.longitude)
    end

    it "uses index access for coordinate containers that do not implement #at" do
      coordinates = Class.new do
        def [](index)
          {0 => -122.399983, 1 => 37.788299}[index]
        end

        def fetch(index)
          value = self[index]
          raise IndexError if value.nil?

          value
        end
      end.new
      point = Twitter::Geo::Point.new(coordinates:)

      assert_in_delta(37.788299, point.longitude)
    end
  end
end
