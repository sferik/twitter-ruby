require "test_helper"

describe Twitter::SourceUser do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::SourceUser.new(id: 1, name: "foo")
      other = Twitter::SourceUser.new(id: 1, name: "bar")

      assert_equal(saved_search, other)
    end

    it "returns false when objects IDs are different" do
      saved_search = Twitter::SourceUser.new(id: 1)
      other = Twitter::SourceUser.new(id: 2)

      refute_equal(saved_search, other)
    end

    it "returns false when classes are different" do
      saved_search = Twitter::SourceUser.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(saved_search, other)
    end
  end
end
