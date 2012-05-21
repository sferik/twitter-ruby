require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#search" do
    before do
      stub_get("/search.json", Twitter.search_endpoint).
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("/search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.search('twitter')
      a_get("/search.json", Twitter.search_endpoint).
        with(:query => {:q => "twitter"}).
        should have_been_made
    end
    it "should return recent statuses related to a query with images and videos embedded" do
      search = @client.search('twitter')
      search.should be_an Array
      search.first.should be_a Twitter::Status
      search.first.text.should == "@KaiserKuo from not too far away your new twitter icon looks like Vader."
    end

    context "when search API responds a malformed result" do
      before do
        stub_get("/search.json", Twitter.search_endpoint).
          with(:query => {:q => "twitter"}).
          to_return(:body => fixture("/search_malformed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "should not fail and return blank Array" do
        search = @client.search('twitter')
        search.should be_an Array
        search.should have(0).items
      end
    end
  end

  describe "#phoenix_search" do
    before do
      stub_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        to_return(:body => fixture("phoenix_search.phoenix"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.phoenix_search('twitter')
      a_get("/phoenix_search.phoenix").
        with(:query => {:q => "twitter"}).
        should have_been_made
    end
    it "should return recent statuses related to a query with images and videos embedded" do
      search = @client.phoenix_search('twitter')
      search.should be_an Array
      search.first.should be_a Twitter::Status
      search.first.text.should == "looking at twitter trends just makes me realize how little i really understand about mankind."
    end
  end

end
