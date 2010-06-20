require 'test_helper'

class GeoTest < Test::Unit::TestCase
  include Twitter

  context "Geographic place lookup" do

    should "work" do
      stub_get 'http://api.twitter.com/1/geo/id/ea76a36c5bc2bdff.json', 'geo_place.json'
      place = Geo.place('ea76a36c5bc2bdff')
      place.country.should == 'The United States of America'
      place.full_name.should == 'Ballantyne West, Charlotte'
      place.geometry.coordinates.should be_kind_of(Array)
    end

  end

  context "Geographic search" do

    should "work" do
      stub_get 'http://api.twitter.com:80/1/geo/search.json?lat=35.061161&long=-80.854568', 'geo_search.json'
      places = Geo.search(:lat => 35.061161, :long => -80.854568)
      places.size.should == 3
      places[0].full_name.should eql('Ballantyne West, Charlotte')
      places[0].name.should eql('Ballantyne West')
    end

    should "be able to search with free form text" do
      stub_get 'http://api.twitter.com/1/geo/search.json?query=princeton%20record%20exchange', 'geo_search_query.json'
      places = Geo.search(:query => 'princeton record exchange')
      places.size.should == 1
      places[0].name.should eql('Princeton Record Exchange')
      places[0].place_type.should eql('poi')
      places[0].attributes.street_address.should eql('20 S Tulane St')
    end

    should "be able to search by ip address" do
      stub_get 'http://api.twitter.com/1/geo/search.json?ip=74.125.19.104', 'geo_search_ip_address.json'
      places = Geo.search(:ip => '74.125.19.104')
      places.size.should == 4
      places[0].full_name.should eql("Mountain View, CA")
      places[0].name.should eql("Mountain View")
      places[1].full_name.should eql("Sunnyvale, CA")
      places[1].name.should eql('Sunnyvale')
    end

  end

  context "Geographic reverse_geocode" do

    should "work" do
      stub_get 'http://api.twitter.com:80/1/geo/reverse_geocode.json?lat=35.061161&long=-80.854568', 'geo_reverse_geocode.json'
      places = Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568)
      places.size.should == 4
      places[0].full_name.should eql('Ballantyne West, Charlotte')
      places[0].name.should eql('Ballantyne West')
    end

    should "be able to limit the number of results returned" do
      stub_get 'http://api.twitter.com/1/geo/reverse_geocode.json?lat=35.061161&max_results=2&long=-80.854568', 'geo_reverse_geocode_limit.json'
      places = Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568, :max_results => 2)
      places.size.should == 2
      places[0].full_name.should eql('Ballantyne West, Charlotte')
      places[0].name.should eql('Ballantyne West')
    end

    should "be able to lookup with granularity" do
      stub_get 'http://api.twitter.com/1/geo/reverse_geocode.json?lat=35.061161&long=-80.854568&granularity=city', 'geo_reverse_geocode_granularity.json'
      places = Geo.reverse_geocode(:lat => 35.061161, :long => -80.854568, :granularity => 'city')
      places.size.should == 3
      places[0].full_name.should eql('Charlotte, NC')
      places[0].name.should eql('Charlotte')
      places[1].full_name.should eql('North Carolina, US')
      places[1].name.should eql('North Carolina')
    end

  end

end
