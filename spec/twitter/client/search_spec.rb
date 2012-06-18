require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#search" do
    before do
      stub_get("/search.json").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("/search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.search('twitter')
      a_get("/search.json").
        with(:query => {:q => "twitter"}).
        should have_been_made
    end
    it "returns recent statuses related to a query with images and videos embedded" do
      search = @client.search('twitter')
      search.should be_a Twitter::SearchResults
      search.results.should be_an Array
      search.results.first.should be_a Twitter::Status
      search.results.first.text.should eq "@KaiserKuo from not too far away your new twitter icon looks like Vader."
    end

    it "returns the max_id value for a search result" do
      search = @client.search('twitter')
      search.max_id.should eq(28857935752)
    end

    context "when search API responds a malformed result" do
      before do
        stub_get("/search.json").
          with(:query => {:q => "twitter"}).
          to_return(:body => fixture("/search_malformed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "returns an empty array" do
        search = @client.search('twitter')
        search.results.should be_an Array
        search.results.should be_empty
      end
    end
  end

  describe "#phoenix_search" do
    before do
      stub_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("phoenix_search.phoenix"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.phoenix_search('twitter')
      a_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        should have_been_made
    end
    it "returns recent statuses related to a query with images and videos embedded" do
      search = @client.phoenix_search('twitter')
      search.should be_an Array
      search.first.should be_a Twitter::Status
      search.first.text.should eq "looking at twitter trends just makes me realize how little i really understand about mankind."
    end
  end

end
