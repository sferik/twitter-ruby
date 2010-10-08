require 'test_helper'

class GeoTest < Test::Unit::TestCase

  context "Geographic place lookup" do
    should "work" do
      stub_get('/1/geo/id/ea76a36c5bc2bdff.json', 'hash.json')
      assert Twitter::Geo.place('ea76a36c5bc2bdff')
    end
  end

  context "Geographic search" do
    should "work" do
      stub_get('/1/geo/search.json?lat=37.783935&long=-122.39361', 'hash.json')
      assert Twitter::Geo.search(:lat => 37.783935, :long => -122.39361)
    end

    should "search with free form text" do
      stub_get('/1/geo/search.json?query=princeton%20record%20exchange', 'hash.json')
      assert Twitter::Geo.search(:query => 'princeton record exchange')
    end

    should "search by ip address" do
      stub_get('/1/geo/search.json?ip=74.125.19.104', 'hash.json')
      assert Twitter::Geo.search(:ip => '74.125.19.104')
    end
  end

  context "Geographic reverse_geocode" do
    should "work" do
      stub_get('/1/geo/reverse_geocode.json?lat=37.783935&long=-122.39361', 'hash.json')
      assert Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361)
    end

    should "limit the number of results returned" do
      stub_get('/1/geo/reverse_geocode.json?lat=37.783935&max_results=2&long=-122.39361', 'hash.json')
      assert  Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361, :max_results => 2)
    end

    should "lookup with granularity" do
      stub_get('/1/geo/reverse_geocode.json?lat=37.783935&long=-122.39361&granularity=city', 'hash.json')
      assert Twitter::Geo.reverse_geocode(:lat => 37.783935, :long => -122.39361, :granularity => 'city')
    end
  end

end
