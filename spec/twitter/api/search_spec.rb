require 'helper'

describe Twitter::API::Search do

  before do
    @client = Twitter::Client.new
  end

  describe "#search" do
    before do
      stub_get("/1.1/search/tweets.json").with(:query => {:q => "twitter"}).to_return(:body => fixture("search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.search("twitter")
      expect(a_get("/1.1/search/tweets.json").with(:query => {:q => "twitter"})).to have_been_made
    end
    it "returns recent Tweets related to a query with images and videos embedded" do
      search = @client.search("twitter")
      expect(search).to be_a Twitter::SearchResults
      expect(search.results).to be_an Array
      expect(search.results.first).to be_a Twitter::Tweet
      expect(search.results.first.text).to eq "Bubble Mailer #freebandnames"
    end
    it "returns the max_id value for a search result" do
      search = @client.search("twitter")
      expect(search.max_id).to eq 250126199840518145
    end

    context "when search API responds a malformed result" do
      before do
        stub_get("/1.1/search/tweets.json").with(:query => {:q => "twitter"}).to_return(:body => fixture("/search_malformed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end

      it "returns an empty array" do
        search = @client.search("twitter")
        expect(search.results).to be_an Array
        expect(search.results).to be_empty
      end
    end
  end

end
