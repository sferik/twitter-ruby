require 'helper'

describe Twitter::NullObject do

  before do
    @null_object = Twitter::NullObject.new
  end

  describe "#nil?" do
    it "returns true" do
      expect(@null_object.null?).to be_true
    end
  end

  describe "calling any method" do
    it "returns self" do
      expect(@null_object.any).to equal @null_object
    end
  end

  describe "#respond_to?" do
    it "returns true" do
      expect(@null_object.respond_to?(:any)).to be_true
    end
  end

end
