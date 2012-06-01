require 'helper'

describe Twitter::SearchResults do

  describe "#completed_in" do
    it "should return completed_in" do
      results = Twitter::SearchResults.new('completed_in' => 23.5)
      results.completed_in.should == 23.5
    end
    it "should return nil when no value exists" do
      results = Twitter::SearchResults.new
      results.completed_in.should be_nil
    end
  end

  describe "#max_id" do
    it "should contain the max_id" do
      results = Twitter::SearchResults.new('max_id' => 123456)
      results.max_id.should == 123456
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.max_id.should be_nil
    end
  end

  describe "#max_id_str" do
    it "should contain the max_id_str" do
      results = Twitter::SearchResults.new('max_id_str' => '123456')
      results.max_id_str.should == '123456'
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.max_id_str.should be_nil
    end
  end

  describe "#next_page" do
    it "should contain the next_page" do
      results = Twitter::SearchResults.new('next_page' => "?page=2&max_id=122078461840982016&q=blue%20angels&rpp=5")
      results.next_page.should == "?page=2&max_id=122078461840982016&q=blue%20angels&rpp=5"
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.next_page.should be_nil
    end
  end

  describe "#page" do
    it "should contain the page" do
      results = Twitter::SearchResults.new('page' => 2)
      results.page.should == 2
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.page.should be_nil
    end
  end

  describe "#query" do
    it "should contain the query" do
      results = Twitter::SearchResults.new('query' => 'blue+angels')
      results.query.should == 'blue+angels'
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.query.should be_nil
    end
  end

  describe "#refresh_url" do
    it "should contain the refresh_url" do
      results = Twitter::SearchResults.new('refresh_url' => '?since_id=122078461840982016&q=blue%20angels')
      results.refresh_url.should == '?since_id=122078461840982016&q=blue%20angels'
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.refresh_url.should be_nil
    end
  end

  describe "#results_per_page" do
    it "should contain the results_per_page" do
      results = Twitter::SearchResults.new('results_per_page' => 10)
      results.results_per_page.should == 10
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.results_per_page.should be_nil
    end
  end

  describe "#since_id" do
    it "should contain the since_id" do
      results = Twitter::SearchResults.new('since_id' => 123456)
      results.since_id.should == 123456
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.since_id.should be_nil
    end
  end

  describe "#since_id_str" do
    it "should contain the since_id_str" do
      results = Twitter::SearchResults.new('since_id_str' => '123456')
      results.since_id_str.should == '123456'
    end
    it "should be nil when no value passed" do
      results = Twitter::SearchResults.new
      results.since_id_str.should be_nil
    end
  end

  describe "#results" do
    it "should contain twitter status objects" do
      search_results = Twitter::SearchResults.new('results' => [{'text' => 'tweet!'}])
      search_results.results.should be_a Array
      search_results.results.first.should be_a Twitter::Status
    end
    it "should be an empty array if no search results passed" do
      search_results = Twitter::SearchResults.new
      search_results.results.should be_a Array
      search_results.results.should == []
    end
  end

  describe "#collection" do
    it "should alias collection to results" do
      search_results = Twitter::SearchResults.new('results' => [{'text' => 'tweet!'}])
      search_results.collection.should be_a Array
      search_results.collection.first.should be_a Twitter::Status
    end
  end
end
