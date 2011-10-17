require 'helper'

describe Twitter::Cursor do

  describe "#first?" do
    context "when previous cursor equals zero" do
      before do
        @cursor = Twitter::Cursor.new({'previous_cursor' => 0}, 'ids')
      end
      it "should return true" do
        @cursor.first?.should be_true
      end
    end
    context "when previous cursor does not equal zero" do
      before do
        @cursor = Twitter::Cursor.new({'previous_cursor' => 1}, 'ids')
      end
      it "should return true" do
        @cursor.first?.should be_false
      end
    end
  end

  describe "#last?" do
    context "when next cursor equals zero" do
      before do
        @cursor = Twitter::Cursor.new({'next_cursor' => 0}, 'ids')
      end
      it "should return true" do
        @cursor.last?.should be_true
      end
    end
    context "when next cursor does not equal zero" do
      before do
        @cursor = Twitter::Cursor.new({'next_cursor' => 1}, 'ids')
      end
      it "should return false" do
        @cursor.last?.should be_false
      end
    end
  end

end
