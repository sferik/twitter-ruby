require "helper"

describe Twitter::Factory do
  describe ".new" do
    it "raises KeyError when attrs are omitted" do
      expect { described_class.new(:type, Twitter::Geo) }.to raise_error(KeyError)
    end

    it "accepts string method names by symbolizing them" do
      geo = described_class.new("type", Twitter::Geo, type: "point", coordinates: [12.34, 56.78])
      expect(geo).to be_a(Twitter::Geo::Point)
    end

    it "calls const_get with a Symbol constant name" do
      product_class = Class.new do
        attr_reader :attrs

        def initialize(attrs)
          @attrs = attrs
        end
      end
      base_class = Class.new
      base_class.define_singleton_method(:const_get) do |name|
        raise TypeError, "expected Symbol" unless name.is_a?(Symbol)
        raise NameError, "unexpected constant #{name}" unless name == :CustomType

        product_class
      end

      object = described_class.new(:type, base_class, type: "custom_type")
      expect(object).to be_a(product_class)
      expect(object.attrs[:type]).to eq("custom_type")
    end
  end
end
