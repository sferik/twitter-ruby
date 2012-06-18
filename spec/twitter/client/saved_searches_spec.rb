require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#saved_searches" do
    context "with ids passed" do
      before do
        stub_get("/1/saved_searches/show/16129012.json").
          to_return(:body => fixture("saved_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.saved_searches(16129012)
        a_get("/1/saved_searches/show/16129012.json").
          should have_been_made
      end
      it "returns an array of saved searches" do
        saved_searches = @client.saved_searches(16129012)
        saved_searches.should be_an Array
        saved_searches.first.should be_a Twitter::SavedSearch
        saved_searches.first.name.should eq "twitter"
      end
    end
    context "without ids passed" do
      before do
        stub_get("/1/saved_searches.json").
          to_return(:body => fixture("saved_searches.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.saved_searches
        a_get("/1/saved_searches.json").
          should have_been_made
      end
      it "returns the authenticated user's saved search queries" do
        saved_searches = @client.saved_searches
        saved_searches.should be_an Array
        saved_searches.first.should be_a Twitter::SavedSearch
        saved_searches.first.name.should eq "twitter"
      end
    end
  end

  describe "#saved_search" do
    before do
      stub_get("/1/saved_searches/show/16129012.json").
        to_return(:body => fixture("saved_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.saved_search(16129012)
      a_get("/1/saved_searches/show/16129012.json").
        should have_been_made
    end
    it "returns a saved search" do
      saved_search = @client.saved_search(16129012)
      saved_search.should be_a Twitter::SavedSearch
      saved_search.name.should eq "twitter"
    end
  end

  describe "#saved_search_create" do
    before do
      stub_post("/1/saved_searches/create.json").
        with(:body => {:query => "twitter"}).
        to_return(:body => fixture("saved_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.saved_search_create("twitter")
      a_post("/1/saved_searches/create.json").
        with(:body => {:query => "twitter"}).
        should have_been_made
    end
    it "returns the created saved search" do
      saved_search = @client.saved_search_create("twitter")
      saved_search.should be_a Twitter::SavedSearch
      saved_search.name.should eq "twitter"
    end
  end

  describe "#saved_search_destroy" do
    before do
      stub_delete("/1/saved_searches/destroy/16129012.json").
        to_return(:body => fixture("saved_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.saved_search_destroy(16129012)
      a_delete("/1/saved_searches/destroy/16129012.json").
        should have_been_made
    end
    it "returns an array of deleted saved searches" do
      saved_searches = @client.saved_search_destroy(16129012)
      saved_searches.should be_an Array
      saved_searches.first.should be_a Twitter::SavedSearch
      saved_searches.first.name.should eq "twitter"
    end
  end

end
