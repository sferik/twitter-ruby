require "test_helper"

describe Twitter::NullObject do
  let(:null_object) { Twitter::NullObject.new }

  describe "#!" do
    it "returns true" do
      refute(null_object)
    end
  end

  describe "#respond_to?" do
    it "returns true for any method" do
      assert_respond_to(null_object, :missing?)
    end
  end

  describe "#instance_of?" do
    it "returns true for Twitter::NullObject" do
      assert_instance_of(Twitter::NullObject, null_object)
    end

    it "returns false for other classes" do
      refute_instance_of(String, null_object)
    end

    it "returns false for non-class arguments" do
      refute(null_object.instance_of?(:not_a_class))
    end
  end

  describe "#kind_of?" do
    it "returns true for Twitter::NullObject" do
      assert_kind_of(Twitter::NullObject, null_object)
    end

    it "returns true for module ancestors" do
      assert_kind_of(Comparable, null_object)
    end

    it "returns true for class ancestors" do
      assert_kind_of(Naught::BasicObject, null_object)
    end

    it "returns false for non-ancestors" do
      refute_kind_of(String, null_object)
    end

    it "returns false for non-module arguments" do
      refute_kind_of(123, null_object)
    end
  end

  describe "#<=>" do
    it "sorts before non-null objects" do
      assert_equal(-1, null_object <=> 1)
    end

    it "is equal to other Twitter::NullObjects" do
      null_object1 = Twitter::NullObject.new
      null_object2 = Twitter::NullObject.new

      assert_equal(0, null_object1 <=> null_object2)
    end
  end

  describe "#nil?" do
    it "returns true" do
      assert_nil(null_object)
    end
  end

  describe "#as_json" do
    it "returns 'null'" do
      assert_equal("null", null_object.as_json)
    end
  end

  describe "#to_json" do
    it "returns JSON" do
      assert_equal('{"null_object":null}', {"null_object" => null_object}.to_json)
    end
  end

  describe "black hole" do
    it "returns self for missing methods" do
      assert_operator(null_object, :equal?, null_object.missing)
    end
  end

  describe "explicit conversions" do
    describe "#to_a" do
      it "returns an empty array" do
        assert_empty(null_object.to_a)
      end
    end

    describe "#to_s" do
      it "returns an empty string" do
        assert_empty(null_object.to_s)
      end
    end
  end

  describe "implicit conversions" do
    describe "#to_ary" do
      it "returns an empty array" do
        assert_empty(null_object.to_ary)
      end
    end

    describe "#to_str" do
      it "returns an empty string" do
        assert_empty(null_object.to_str)
      end
    end
  end

  describe "predicates" do
    it "return false for missing methods" do
      refute_predicate(null_object, :missing?)
    end
  end

  describe "#presence" do
    it "returns nil" do
      assert_nil(null_object.presence)
    end
  end

  describe "#blank?" do
    it "returns true" do
      assert_predicate(null_object, :blank?)
    end
  end

  describe "#present?" do
    it "returns false" do
      refute_predicate(null_object, :present?)
    end
  end
end
