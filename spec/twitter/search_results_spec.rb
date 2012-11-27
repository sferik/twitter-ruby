require 'helper'

describe Twitter::SearchResults do

  describe "#statuses" do
    it "returns an array of Tweets" do
      statuses = Twitter::SearchResults.new(:statuses => [{:id => 25938088801, :text => 'tweet!'}]).statuses
      expect(statuses).to be_an Array
      expect(statuses.first).to be_a Twitter::Tweet
    end
    it "is empty when not set" do
      statuses = Twitter::SearchResults.new.statuses
      expect(statuses).to be_empty
    end
  end

  describe "#completed_in" do
    it "returns a number of seconds" do
      completed_in = Twitter::SearchResults.new(:search_metadata => {:completed_in => 0.029}).completed_in
      expect(completed_in).to be_a Float
      expect(completed_in).to eq 0.029
    end
    it "is nil when not set" do
      completed_in = Twitter::SearchResults.new.completed_in
      expect(completed_in).to be_nil
    end
  end

  describe "#max_id" do
    it "returns an ID" do
      max_id = Twitter::SearchResults.new(:search_metadata => {:max_id => 250126199840518145}).max_id
      expect(max_id).to be_an Integer
      expect(max_id).to eq 250126199840518145
    end
    it "is nil when not set" do
      max_id = Twitter::SearchResults.new.max_id
      expect(max_id).to be_nil
    end
  end

  describe "#page" do
    it "returns page number" do
      page = Twitter::SearchResults.new(:search_metadata => {:page => 1}).page
      expect(page).to be_an Integer
      expect(page).to eq 1
    end
    it "is nil when not set" do
      page = Twitter::SearchResults.new.page
      expect(page).to be_nil
    end
  end

  describe "#query" do
    it "returns the query" do
      query = Twitter::SearchResults.new(:search_metadata => {:query => "%23freebandnames"}).query
      expect(query).to be_a String
      expect(query).to eq "%23freebandnames"
    end
    it "is nil when not set" do
      query = Twitter::SearchResults.new.query
      expect(query).to be_nil
    end
  end

  describe "#results_per_page" do
    it "returns the number of results per page" do
      results_per_page = Twitter::SearchResults.new(:search_metadata => {:results_per_page => 4}).results_per_page
      expect(results_per_page).to be_an Integer
      expect(results_per_page).to eq 4
    end
    it "is nil when not set" do
      results_per_page = Twitter::SearchResults.new.results_per_page
      expect(results_per_page).to be_nil
    end
  end

  describe "#search_metadata?" do
    it "returns true when search_metadata is set" do
      search_metadata = Twitter::SearchResults.new(:search_metadata => {}).search_metadata?
      expect(search_metadata).to be_true
    end
    it "returns false when search_metadata is not set" do
      search_metadata = Twitter::SearchResults.new.search_metadata?
      expect(search_metadata).to be_false
    end
  end

  describe "#since_id" do
    it "returns an ID" do
      since_id = Twitter::SearchResults.new(:search_metadata => {:since_id => 250126199840518145}).since_id
      expect(since_id).to be_an Integer
      expect(since_id).to eq 250126199840518145
    end
    it "is nil when not set" do
      since_id = Twitter::SearchResults.new.since_id
      expect(since_id).to be_nil
    end
  end

end
