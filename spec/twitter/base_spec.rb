require 'helper'

describe Twitter::Base do

  before do
    @base = Twitter::Base.new('id' => 1)
  end

  describe "#[]" do
    it "should be able to call methods using [] with symbol" do
      @base[:object_id].should be_an Integer
    end
    it "should be able to call methods using [] with string" do
      @base['object_id'].should be_an Integer
    end
  end

end
