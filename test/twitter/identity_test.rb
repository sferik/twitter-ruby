require "test_helper"

describe Twitter::Identity do
  describe "#initialize" do
    it "raises an IndexError when id is not specified" do
      assert_raises(KeyError) { Twitter::Identity.new }
    end
  end

  describe "#==" do
    it "returns true when objects IDs are the same" do
      one = Twitter::Identity.new(id: 1, screen_name: "sferik")
      two = Twitter::Identity.new(id: 1, screen_name: "garybernhardt")

      assert_equal(one, two)
    end

    it "returns false when objects IDs are different" do
      one = Twitter::Identity.new(id: 1)
      two = Twitter::Identity.new(id: 2)

      refute_equal(one, two)
    end

    it "returns false when classes are different" do
      one = Twitter::Identity.new(id: 1)
      two = Twitter::Base.new(id: 1)

      refute_equal(one, two)
    end
  end
end
