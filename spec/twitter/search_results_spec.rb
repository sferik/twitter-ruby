require 'helper'

describe Twitter::SearchResults do

  describe "#results" do
    it "contains twitter status objects" do
      results = Twitter::SearchResults.new(:results => [{:id => 25938088801, :text => 'tweet!'}]).results
      results.should be_an Array
      results.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      results = Twitter::SearchResults.new.results
      results.should be_empty
    end
  end

end
