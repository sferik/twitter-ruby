require "test_helper"

describe Twitter::Factory do
  describe ".new" do
    it "raises KeyError when attrs are omitted" do
      assert_raises(KeyError) { Twitter::Factory.new(:type, Twitter::Geo) }
    end

    it "accepts string method names by symbolizing them" do
      geo = Twitter::Factory.new("type", Twitter::Geo, type: "point", coordinates: [12.34, 56.78])

      assert_kind_of(Twitter::Geo::Point, geo)
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

      object = Twitter::Factory.new(:type, base_class, type: "custom_type")

      assert_kind_of(product_class, object)
      assert_equal("custom_type", object.attrs[:type])
    end
  end
end
