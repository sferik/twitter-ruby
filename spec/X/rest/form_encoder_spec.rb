require "helper"

describe X::REST::FormEncoder do
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

    it "encodes asterisk correctly" do
      expect(described_class.encode({status: "Update *"})).to eq("status=Update%20%2A")
    end
  end
end
