require 'test_helper'

class GeoTest < Test::Unit::TestCase
  include Twitter

  context "Geographic place lookup" do
    should "work" do
      stub_get('/1/geo/id/ea76a36c5bc2bdff.json', 'geo_place.json')
      assert Twitter::Geo.place('ea76a36c5bc2bdff')
    end
  end

  context "Geographic search" do
    should "work" do
      stub_get('/1/geo/search.json?lat=35.061161&long=-80.854568', 'geo_search.json')
      assert Twitter::Geo.search(:lat => 35.061161, :long => -80.854568)
    end

    should "search with free form text" do
      stub_get('/1/geo/search.json?query=princeton%20record%20exchange', 'geo_search_query.json')
      assert Twitter::Geo.search(:query => 'princeton record exchange')
    end

    should "search by ip address" do
      stub_get('/1/geo/search.json?ip=74.125.19.104', 'geo_search_ip_address.json')
      assert Twitter::Geo.search(:ip => '74.125.19.104')
    end
  end

  context "Geographic reverse_geocode" do
    should "work" do
      stub_get('/1/geo/reverse_geocode.json?lat=35.061161&long=-80.854568', 'geo_reverse_geocode.json')
      assert Twitter::Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568)
    end

    should "limit the number of results returned" do
      stub_get('/1/geo/reverse_geocode.json?lat=35.061161&max_results=2&long=-80.854568', 'geo_reverse_geocode_limit.json')
      assert  Twitter::Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568, :max_results => 2)
    end

    should "lookup with granularity" do
      stub_get('/1/geo/reverse_geocode.json?lat=35.061161&long=-80.854568&granularity=city', 'geo_reverse_geocode_granularity.json')
      assert Twitter::Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568, :granularity => 'city')
    end
  end

end
