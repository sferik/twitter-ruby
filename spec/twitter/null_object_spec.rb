require 'helper'

describe Twitter::NullObject do

  describe "#null?" do
    it "returns true" do
      null_object = Twitter::NullObject.new
      expect(null_object.null?).to be_true
    end
  end

  describe "#!" do
    it "returns true" do
      null_object = Twitter::NullObject.new
      expect(!null_object).to be_true
    end
  end

end
