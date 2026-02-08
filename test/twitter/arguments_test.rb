require "helper"

describe Twitter::Arguments do
  describe "#initialize" do
    it "extracts options hash from the end of arguments" do
      args = Twitter::Arguments.new([1, 2, {foo: "bar"}])
      expect(args.options).to eq(foo: "bar")
      expect(args.to_a).to eq([1, 2])
    end

    it "returns empty hash when no options provided" do
      args = Twitter::Arguments.new([1, 2, 3])
      expect(args.options).to eq({})
      expect(args.to_a).to eq([1, 2, 3])
    end

    it "flattens nested arrays" do
      args = Twitter::Arguments.new([[1, 2], [3, 4]])
      expect(args.to_a).to eq([1, 2, 3, 4])
    end

    it "accepts Hash subclasses as options" do
      custom_hash_class = Class.new(Hash)
      custom = custom_hash_class.new
      custom[:key] = "value"
      args = Twitter::Arguments.new([1, custom])
      expect(args.options).to eq(key: "value")
      expect(args.to_a).to eq([1])
    end
  end
end
