require 'helper'

describe Twitter::GeoResults do

  describe "#each" do
    before do
      @geo_results = Twitter::GeoResults.new(:result => {:places => [{:id => 1}, {:id => 2}, {:id => 3}, {:id => 4}, {:id => 5}, {:id => 6}]})
    end
    it "iterates" do
      count = 0
      @geo_results.each{count += 1}
      expect(count).to eq(6)
    end
    context "with start" do
      it "iterates" do
        count = 0
        @geo_results.each(5){count += 1}
        expect(count).to eq(1)
      end
    end
  end

  describe "#token" do
    it "returns a String when token is set" do
      geo_results = Twitter::GeoResults.new(:result => {}, :token => "abc123")
      expect(geo_results.token).to be_a String
      expect(geo_results.token).to eq("abc123")
    end
    it "returns nil when token is not set" do
      geo_results = Twitter::GeoResults.new(:result => {})
      expect(geo_results.token).to be_nil
    end
  end

end
