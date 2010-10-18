require 'test_helper'

class GeoTest < Test::Unit::TestCase
  context "Geographic place lookup" do
    setup do
      Twitter.format = 'json'
    end

    should "work" do
      stub_get("geo/id/ea76a36c5bc2bdff.json", "hash.json")
      assert Twitter::Geo.place('ea76a36c5bc2bdff')
    end
  end

  context "Geographic search" do
    setup do
      Twitter.format = 'json'
    end

    should "work" do
      stub_get("geo/search.json?lat=37.783935&long=-122.39361", "hash.json")
      assert Twitter::Geo.search(:lat => 37.783935, :long => -122.39361)
    end

    should "search with free form text" do
      stub_get("geo/search.json?query=princeton%20record%20exchange", "hash.json")
      assert Twitter::Geo.search(:query => 'princeton record exchange')
    end

    should "search by ip address" do
      stub_get("geo/search.json?ip=74.125.19.104", "hash.json")
      assert Twitter::Geo.search(:ip => '74.125.19.104')
    end
  end

  context "Geographic reverse_geocode" do
    setup do
      Twitter.format = 'json'
    end

    should "work" do
      stub_get("geo/reverse_geocode.json?lat=37.783935&long=-122.39361", "hash.json")
      assert Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361)
    end

    should "limit the number of results returned" do
      stub_get("geo/reverse_geocode.json?lat=37.783935&max_results=2&long=-122.39361", "hash.json")
      assert Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361, :max_results => 2)
    end

    should "lookup with granularity" do
      stub_get("geo/reverse_geocode.json?lat=37.783935&long=-122.39361&granularity=city", "hash.json")
      assert Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361, :granularity => 'city')
    end
  end

  context "Geographically similar places" do
    setup do
      Twitter.format = 'json'
    end

    should "work" do
      stub_get("geo/similar_places.json?lat=37.783935&long=-122.39361&name=Twitter%20HQ", "hash.json")
      assert Twitter::Geo.similar_places(:lat => 37.783935, :long => -122.39361, :name => "Twitter HQ")
    end
  end

  context "Creating places" do
    setup do
      Twitter.format = 'json'
    end

    should "work" do
      stub_post("geo/place.json", "hash.json")
      Twitter.configure do |config|
        config.consumer_key = 'ctoken'
        config.consumer_secret = 'csecret'
        config.access_key = 'atoken'
        config.access_secret = 'asecret'
      end

      info = {
        :name => 'Twitter HQ',
        :contained_within => '247f43d441defc03',
        :token => '36179c9bf78835898ebf521c1defd4be',
        :lat => 37.7821120598956,
        :long => -122.400612831116
      }
      assert Twitter::Geo.create_place(info)
    end
  end
end
