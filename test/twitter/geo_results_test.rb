require "helper"

describe Twitter::GeoResults do
  describe "#each" do
    before do
      @geo_results = described_class.new(result: {places: [{id: 1}, {id: 2}, {id: 3}, {id: 4}, {id: 5}, {id: 6}]})
    end

    it "iterates" do
      count = 0
      @geo_results.each { count += 1 }
      expect(count).to eq(6)
    end

    it "wraps each place as a Twitter::Place object" do
      first_place = @geo_results.first
      expect(first_place).to be_a(Twitter::Place)
      expect(first_place.id).to eq(1)
    end

    context "with start" do
      it "iterates" do
        count = 0
        @geo_results.each(5) { count += 1 }
        expect(count).to eq(1)
      end
    end
  end

  describe "#initialize" do
    it "supports being initialized without attrs" do
      geo_results = described_class.new
      expect(geo_results.attrs).to eq({})
      expect(geo_results.to_a).to eq([])
    end

    it "treats nil attrs as an empty hash" do
      geo_results = described_class.new(nil)
      expect(geo_results.attrs).to eq({})
      expect(geo_results.to_a).to eq([])
    end
  end

  describe "#token" do
    it "returns a String when token is set" do
      geo_results = described_class.new(result: {}, token: "abc123")
      expect(geo_results.token).to be_a String
      expect(geo_results.token).to eq("abc123")
    end

    it "returns nil when token is not set" do
      geo_results = described_class.new(result: {})
      expect(geo_results.token).to be_nil
    end
  end

  describe "#reached_limit? (private)" do
    it "returns false as a strict boolean" do
      geo_results = described_class.new(result: {})
      expect(geo_results.send(:reached_limit?)).to eq(false)
    end
  end
end
