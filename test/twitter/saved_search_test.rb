require "test_helper"

describe Twitter::SavedSearch do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::SavedSearch.new(id: 1, name: "foo")
      other = Twitter::SavedSearch.new(id: 1, name: "bar")

      assert_equal(saved_search, other)
    end

    it "returns false when objects IDs are different" do
      saved_search = Twitter::SavedSearch.new(id: 1)
      other = Twitter::SavedSearch.new(id: 2)

      refute_equal(saved_search, other)
    end

    it "returns false when classes are different" do
      saved_search = Twitter::SavedSearch.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(saved_search, other)
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_kind_of(Time, saved_search.created_at)
      assert_predicate(saved_search.created_at, :utc?)
    end

    it "returns nil when created_at is not set" do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012)

      assert_nil(saved_search.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_predicate(saved_search, :created?)
    end

    it "returns false when created_at is not set" do
      saved_search = Twitter::SavedSearch.new(id: 16_129_012)

      refute_predicate(saved_search, :created?)
    end
  end
end
