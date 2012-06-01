require 'helper'

describe Twitter::SearchResults do

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

end
