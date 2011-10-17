require 'helper'

describe Twitter::Suggestion do

  before do
    @suggestion = Twitter::Suggestion.new('slug' => 'art-design')
  end

  describe "#==" do
    it "should return true when slugs are equal" do
      other = Twitter::Suggestion.new('slug' => 'art-design')
      (@suggestion == other).should be_true
    end
    it "should return false when coordinates are not equal" do
      other = Twitter::Suggestion.new('slug' => 'design-art')
      (@suggestion == other).should be_false
    end
  end

end
