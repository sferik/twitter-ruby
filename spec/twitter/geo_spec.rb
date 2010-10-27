require File.expand_path('../../spec_helper', __FILE__)

describe "Twitter::Geo" do
  context ".new" do
    before do
      @client = Twitter::Geo.new
    end

    describe ".reverse_geocode" do

      before do
        stub_get("geo/reverse_geocode.json").
          with(:query => {"lat" => "37.7821120598956", "long" => "-122.400612831116"}).
          to_return(:body => fixture("places.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should get the correct resource" do
        @client.reverse_geocode(:lat => "37.7821120598956", :long => "-122.400612831116")
        a_get("geo/reverse_geocode.json").
          with(:query => {"lat" => "37.7821120598956", "long" => "-122.400612831116"}).
          should have_been_made
      end
    end
  end
end
