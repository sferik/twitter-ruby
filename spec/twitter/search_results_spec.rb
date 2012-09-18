require 'helper'

describe Twitter::SearchResults do

  describe "#statuses" do
    it "returns an array of Tweets" do
      statuses = Twitter::SearchResults.new(:statuses => [{:id => 25938088801, :text => 'tweet!'}]).statuses
      statuses.should be_an Array
      statuses.first.should be_a Twitter::Tweet
    end
    it "is empty when not set" do
      statuses = Twitter::SearchResults.new.statuses
      statuses.should be_empty
    end
  end

  describe "#completed_in" do
    it "returns a number of seconds" do
      completed_in = Twitter::SearchResults.new(:search_metadata => {:completed_in => 0.029}).completed_in
      completed_in.should be_a Float
      completed_in.should eq 0.029
    end
    it "is nil when not set" do
      completed_in = Twitter::SearchResults.new.completed_in
      completed_in.should be_nil
    end
  end

  describe "#max_id" do
    it "returns an ID" do
      max_id = Twitter::SearchResults.new(:search_metadata => {:max_id => 250126199840518145}).max_id
      max_id.should be_an Integer
      max_id.should eq 250126199840518145
    end
    it "is nil when not set" do
      max_id = Twitter::SearchResults.new.max_id
      max_id.should be_nil
    end
  end

  describe "#page" do
    it "returns page number" do
      page = Twitter::SearchResults.new(:search_metadata => {:page => 1}).page
      page.should be_an Integer
      page.should eq 1
    end
    it "is nil when not set" do
      page = Twitter::SearchResults.new.page
      page.should be_nil
    end
  end

  describe "#query" do
    it "returns the query" do
      query = Twitter::SearchResults.new(:search_metadata => {:query => "%23freebandnames"}).query
      query.should be_a String
      query.should eq "%23freebandnames"
    end
    it "is nil when not set" do
      query = Twitter::SearchResults.new.query
      query.should be_nil
    end
  end

  describe "#results_per_page" do
    it "returns the number of results per page" do
      results_per_page = Twitter::SearchResults.new(:search_metadata => {:results_per_page => 4}).results_per_page
      results_per_page.should be_an Integer
      results_per_page.should eq 4
    end
    it "is nil when not set" do
      results_per_page = Twitter::SearchResults.new.results_per_page
      results_per_page.should be_nil
    end
  end

  describe "#since_id" do
    it "returns an ID" do
      since_id = Twitter::SearchResults.new(:search_metadata => {:since_id => 250126199840518145}).since_id
      since_id.should be_an Integer
      since_id.should eq 250126199840518145
    end
    it "is nil when not set" do
      since_id = Twitter::SearchResults.new.since_id
      since_id.should be_nil
    end
  end

end
