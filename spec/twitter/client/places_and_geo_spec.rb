require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#places_nearby" do
    before do
      stub_get("/1/geo/search.json").
        with(:query => {:ip => "74.125.19.104"}).
        to_return(:body => fixture("places.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.places_nearby(:ip => "74.125.19.104")
      a_get("/1/geo/search.json").
        with(:query => {:ip => "74.125.19.104"}).
        should have_been_made
    end
    it "returns nearby places" do
      places = @client.places_nearby(:ip => "74.125.19.104")
      places.should be_an Array
      places.first.name.should eq "Bernal Heights"
    end
  end

  describe "#places_similar" do
    before do
      stub_get("/1/geo/similar_places.json").
        with(:query => {:lat => "37.7821120598956", :long => "-122.400612831116", :name => "Twitter HQ"}).
        to_return(:body => fixture("places.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.places_similar(:lat => "37.7821120598956", :long => "-122.400612831116", :name => "Twitter HQ")
      a_get("/1/geo/similar_places.json").
        with(:query => {:lat => "37.7821120598956", :long => "-122.400612831116", :name => "Twitter HQ"}).
        should have_been_made
    end
    it "returns similar places" do
      places = @client.places_similar(:lat => "37.7821120598956", :long => "-122.400612831116", :name => "Twitter HQ")
      places.should be_an Array
      places.first.name.should eq "Bernal Heights"
    end
  end

  describe "#reverse_geocode" do
    before do
      stub_get("/1/geo/reverse_geocode.json").
        with(:query => {:lat => "37.7821120598956", :long => "-122.400612831116"}).
        to_return(:body => fixture("places.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.reverse_geocode(:lat => "37.7821120598956", :long => "-122.400612831116")
      a_get("/1/geo/reverse_geocode.json").
        with(:query => {:lat => "37.7821120598956", :long => "-122.400612831116"}).
        should have_been_made
    end
    it "returns places" do
      places = @client.reverse_geocode(:lat => "37.7821120598956", :long => "-122.400612831116")
      places.should be_an Array
      places.first.name.should eq "Bernal Heights"
    end
  end

  describe "#place" do
    before do
      stub_get("/1/geo/id/247f43d441defc03.json").
        to_return(:body => fixture("place.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.place("247f43d441defc03")
      a_get("/1/geo/id/247f43d441defc03.json").
        should have_been_made
    end
    it "returns a place" do
      place = @client.place("247f43d441defc03")
      place.name.should eq "Twitter HQ"
    end
  end

  describe "#place_create" do
    before do
      stub_post("/1/geo/place.json").
        with(:body => {:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581"}).
        to_return(:body => fixture("place.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.place_create(:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581")
      a_post("/1/geo/place.json").
        with(:body => {:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581"}).
        should have_been_made
    end
    it "returns a place" do
      place = @client.place_create(:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581")
      place.name.should eq "Twitter HQ"
    end
  end

end
