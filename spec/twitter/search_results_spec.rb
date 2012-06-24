require 'helper'

describe Twitter::SearchResults do

  describe "#results" do
    it "contains twitter status objects" do
      search_results = Twitter::SearchResults.new(:results => [{:text => 'tweet!'}])
      search_results.results.should be_a Array
      search_results.results.first.should be_a Twitter::Status
    end
    it "is an empty array if no search results passed" do
      search_results = Twitter::SearchResults.new
      search_results.results.should be_a Array
      search_results.results.should eq []
    end
  end

end
