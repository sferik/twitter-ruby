require "test_helper"

describe Twitter::REST::FormEncoder do
  describe ".encode" do
    it "form encodes values values" do
      assert_equal("foo=%3C%3E&bar=%2B%26", Twitter::REST::FormEncoder.encode({foo: "<>", bar: "+&"}))
    end

    it "handles nil values" do
      assert_equal("noval", Twitter::REST::FormEncoder.encode({noval: nil}))
    end

    it "handles arrays" do
      assert_equal("array=1&array=2&array=3", Twitter::REST::FormEncoder.encode({array: [1, 2, 3]}))
    end

    it "handles arrays with nil values" do
      assert_equal("array=1&array&array=3", Twitter::REST::FormEncoder.encode({array: [1, nil, 3]}))
    end

    it "encodes asterisk correctly" do
      assert_equal("status=Update%20%2A", Twitter::REST::FormEncoder.encode({status: "Update *"}))
    end

    it "encodes keys that need escaping" do
      assert_equal("foo%20bar=value", Twitter::REST::FormEncoder.encode({"foo bar" => "value"}))
    end

    it "handles array-like objects with to_ary" do
      array_like_class = Class.new do
        def to_ary
          [1, 2]
        end
      end

      assert_equal("arr=1&arr=2", Twitter::REST::FormEncoder.encode({arr: array_like_class.new}))
    end

    it "encodes array values that need escaping" do
      assert_equal("arr=a%20b&arr=c%26d", Twitter::REST::FormEncoder.encode({arr: ["a b", "c&d"]}))
    end

    it "encodes nil value with key that needs escaping" do
      assert_equal("foo%20bar", Twitter::REST::FormEncoder.encode({"foo bar" => nil}))
    end

    it "encodes array key that needs escaping" do
      assert_equal("foo%20bar=1&foo%20bar=2", Twitter::REST::FormEncoder.encode({"foo bar" => [1, 2]}))
    end

    it "encodes array with nil values where key needs escaping" do
      assert_equal("foo%20bar=1&foo%20bar&foo%20bar=2", Twitter::REST::FormEncoder.encode({"foo bar" => [1, nil, 2]}))
    end
  end
end
