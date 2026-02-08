require "test_helper"

describe Twitter::BasicUser do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::BasicUser.new(id: 1, name: "foo")
      other = Twitter::BasicUser.new(id: 1, name: "bar")

      assert_equal(saved_search, other)
    end

    it "returns false when objects IDs are different" do
      saved_search = Twitter::BasicUser.new(id: 1)
      other = Twitter::BasicUser.new(id: 2)

      refute_equal(saved_search, other)
    end

    it "returns false when classes are different" do
      saved_search = Twitter::BasicUser.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(saved_search, other)
    end
  end
end
