require "helper"

describe Twitter::REST::FormEncoder do
  describe ".encode" do
    it "form encodes values values" do
      expect(described_class.encode({foo: "<>", bar: "+&"})).to eq("foo=%3C%3E&bar=%2B%26")
    end

    it "handles nil values" do
      expect(described_class.encode({noval: nil})).to eq("noval")
    end

    it "handles arrays" do
      expect(described_class.encode({array: [1, 2, 3]})).to eq("array=1&array=2&array=3")
    end

    it "handles arrays with nil values" do
      expect(described_class.encode({array: [1, nil, 3]})).to eq("array=1&array&array=3")
    end

    it "encodes asterisk correctly" do
      expect(described_class.encode({status: "Update *"})).to eq("status=Update%20%2A")
    end

    it "encodes keys that need escaping" do
      expect(described_class.encode({"foo bar" => "value"})).to eq("foo%20bar=value")
    end

    it "handles array-like objects with to_ary" do
      array_like_class = Class.new do
        def to_ary
          [1, 2]
        end
      end
      expect(described_class.encode({arr: array_like_class.new})).to eq("arr=1&arr=2")
    end

    it "encodes array values that need escaping" do
      expect(described_class.encode({arr: ["a b", "c&d"]})).to eq("arr=a%20b&arr=c%26d")
    end

    it "encodes nil value with key that needs escaping" do
      expect(described_class.encode({"foo bar" => nil})).to eq("foo%20bar")
    end

    it "encodes array key that needs escaping" do
      expect(described_class.encode({"foo bar" => [1, 2]})).to eq("foo%20bar=1&foo%20bar=2")
    end

    it "encodes array with nil values where key needs escaping" do
      expect(described_class.encode({"foo bar" => [1, nil, 2]})).to eq("foo%20bar=1&foo%20bar&foo%20bar=2")
    end
  end
end
