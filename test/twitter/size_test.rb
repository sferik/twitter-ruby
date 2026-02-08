require "test_helper"

describe Twitter::Size do
  describe "#==" do
    it "returns true for empty objects" do
      size = Twitter::Size.new
      other = Twitter::Size.new

      assert_equal(size, other)
    end

    it "returns true when objects height and width are the same" do
      size = Twitter::Size.new(h: 1, w: 1, resize: true)
      other = Twitter::Size.new(h: 1, w: 1, resize: false)

      assert_equal(size, other)
    end

    it "returns false when objects height or width are different" do
      size = Twitter::Size.new(h: 1, w: 1)
      other = Twitter::Size.new(h: 1, w: 2)

      refute_equal(size, other)
    end

    it "returns false when classes are different" do
      size = Twitter::Size.new(h: 1, w: 1)
      other = Twitter::Base.new(h: 1, w: 1)

      refute_equal(size, other)
    end
  end
end
