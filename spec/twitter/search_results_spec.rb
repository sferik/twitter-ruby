require 'helper'

describe Twitter::SearchResults do

  describe "#each" do
    before do
      @search_results = Twitter::SearchResults.new(:statuses => [{:id => 1}, {:id => 2}, {:id => 3}, {:id => 4}, {:id => 5}, {:id => 6}])
    end
    it "iterates" do
      count = 0
      @search_results.each{count += 1}
      expect(count).to eq(6)
    end
    context "with start" do
      it "iterates" do
        count = 0
        @search_results.each(5){count += 1}
        expect(count).to eq(1)
      end
    end
  end

  describe "#completed_in" do
    it "returns a number of seconds" do
      completed_in = Twitter::SearchResults.new(:search_metadata => {:completed_in => 0.029}).completed_in
      expect(completed_in).to be_a Float
      expect(completed_in).to eq(0.029)
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
      expect(max_id).to eq(250126199840518145)
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
      expect(page).to eq(1)
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
      expect(query).to eq("%23freebandnames")
    end
    it "is nil when not set" do
      query = Twitter::SearchResults.new.query
      expect(query).to be_nil
    end
  end

  describe "#results_per_page" do
    it "returns the number of results per page" do
      results_per_page = Twitter::SearchResults.new(:search_metadata => {:count => 4}).results_per_page
      expect(results_per_page).to be_an Integer
      expect(results_per_page).to eq(4)
    end
    it "is nil when not set" do
      results_per_page = Twitter::SearchResults.new.results_per_page
      expect(results_per_page).to be_nil
    end
  end

  describe "#since_id" do
    it "returns an ID" do
      since_id = Twitter::SearchResults.new(:search_metadata => {:since_id => 250126199840518145}).since_id
      expect(since_id).to be_an Integer
      expect(since_id).to eq(250126199840518145)
    end
    it "is nil when not set" do
      since_id = Twitter::SearchResults.new.since_id
      expect(since_id).to be_nil
    end
  end

  describe "#next_results?" do
    it "returns true when next_results is set" do
      next_results = Twitter::SearchResults.new(:search_metadata => {:next_results => "?"}).next_results?
      expect(next_results).to be_true
    end
    it "returns false when next_results is not set" do
      next_results = Twitter::SearchResults.new(:search_metadata => {}).next_results?
      expect(next_results).to be_false
    end
    it "returns false is search_metadata is not set" do
      next_results = Twitter::SearchResults.new().next_results?
      expect(next_results).to be_false
    end
  end

  describe "#next_results" do
    it "returns a hash of query parameters" do
      search_results = Twitter::SearchResults.new(:search_metadata => {:next_results => "?max_id=249279667666817023&q=%23freebandnames&count=4&include_entities=1&result_type=mixed"})
      expect(search_results.next_results).to be_a Hash
      expect(search_results.next_results[:max_id]).to eq("249279667666817023")
    end
  end

  describe "#refresh_results" do
    it "returns a hash of query parameters" do
      search_results = Twitter::SearchResults.new(:search_metadata => {:refresh_url => "?since_id=249279667666817023&q=%23freebandnames&count=4&include_entities=1&result_type=recent"})
      expect(search_results.refresh_results).to be_a Hash
      expect(search_results.refresh_results[:since_id]).to eq("249279667666817023")
    end
  end

end
