require "test_helper"

describe Twitter::TrendResults do
  describe "#initialize" do
    it "supports initialization without attrs" do
      trend_results = Twitter::TrendResults.new

      assert_empty(trend_results.attrs)
      assert_empty(trend_results.to_a)
    end
  end

  describe "#as_of" do
    it "returns a Time when as_of is set" do
      trend_results = Twitter::TrendResults.new(id: 1, as_of: "2012-08-24T23:25:43Z")

      assert_kind_of(Time, trend_results.as_of)
      assert_predicate(trend_results.as_of, :utc?)
    end

    it "returns nil when as_of is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      assert_nil(trend_results.as_of)
    end
  end

  describe "#as_of?" do
    it "returns true when as_of is set" do
      trend_results = Twitter::TrendResults.new(id: 1, as_of: "2012-08-24T23:24:14Z")

      assert_predicate(trend_results, :as_of?)
    end

    it "returns false when as_of is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      refute_predicate(trend_results, :as_of?)
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      trend_results = Twitter::TrendResults.new(id: 1, created_at: "2012-08-24T23:24:14Z")

      assert_kind_of(Time, trend_results.created_at)
      assert_predicate(trend_results.created_at, :utc?)
    end

    it "returns nil when created_at is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      assert_nil(trend_results.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      trend_results = Twitter::TrendResults.new(id: 1, created_at: "2012-08-24T23:24:14Z")

      assert_predicate(trend_results, :created?)
    end

    it "returns false when created_at is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      refute_predicate(trend_results, :created?)
    end
  end

  describe "#each" do
    before do
      @trend_results = Twitter::TrendResults.new(trends: [{name: "foo"}, {name: "bar"}, {name: "baz"}, {name: "qux"}, {name: "quux"}, {name: "corge"}])
    end

    it "iterates" do
      count = 0
      @trend_results.each { count += 1 }

      assert_equal(6, count)
    end

    it "contains Trend objects with correct data" do
      assert_kind_of(Twitter::Trend, @trend_results.first)
      assert_equal("foo", @trend_results.first.name)
    end

    describe "with start" do
      it "iterates" do
        count = 0
        @trend_results.each(5) { count += 1 }

        assert_equal(1, count)
      end
    end
  end

  describe "#location" do
    it "returns a Twitter::Place when location is set" do
      trend_results = Twitter::TrendResults.new(id: 1, locations: [{name: "Worldwide", woeid: 1}])

      assert_kind_of(Twitter::Place, trend_results.location)
    end

    it "returns nil when location is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      assert_nil(trend_results.location)
    end
  end

  describe "#location?" do
    it "returns true when location is set" do
      trend_results = Twitter::TrendResults.new(id: 1, locations: [{name: "Worldwide", woeid: 1}])

      assert_predicate(trend_results, :location?)
    end

    it "returns false when location is not set" do
      trend_results = Twitter::TrendResults.new(id: 1)

      refute_predicate(trend_results, :location?)
    end
  end
end
