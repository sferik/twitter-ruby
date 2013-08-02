require 'helper'

describe Twitter::NullObject do

  describe "#nil?" do
    it "returns true" do
      null_object = Twitter::NullObject.instance
      expect(null_object.null?).to be_true
    end
  end

  describe "#respond_to?" do
    it "returns true" do
      null_object = Twitter::NullObject.instance
      expect(null_object.respond_to?(:method)).to be_true
    end
  end

end
