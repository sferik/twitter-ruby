require "test_helper"

describe Twitter::Arguments do
  describe "#initialize" do
    it "extracts options hash from the end of arguments" do
      args = Twitter::Arguments.new([1, 2, {foo: "bar"}])

      assert_equal({foo: "bar"}, args.options)
      assert_equal([1, 2], args.to_a)
    end

    it "returns empty hash when no options provided" do
      args = Twitter::Arguments.new([1, 2, 3])

      assert_empty(args.options)
      assert_equal([1, 2, 3], args.to_a)
    end

    it "flattens nested arrays" do
      args = Twitter::Arguments.new([[1, 2], [3, 4]])

      assert_equal([1, 2, 3, 4], args.to_a)
    end

    it "accepts Hash subclasses as options" do
      custom_hash_class = Class.new(Hash)
      custom = custom_hash_class.new
      custom[:key] = "value"
      args = Twitter::Arguments.new([1, custom])

      assert_equal({key: "value"}, args.options)
      assert_equal([1], args.to_a)
    end
  end
end
