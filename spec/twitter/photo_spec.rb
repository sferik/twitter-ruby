require 'helper'

describe Twitter::Photo do

  describe "#==" do
    it "should return true when ids and classes are equal" do
      photo = Twitter::Photo.new('id' => 1)
      other = Twitter::Photo.new('id' => 1)
      (photo == other).should be_true
    end
    it "should return false when classes are not equal" do
      photo = Twitter::Photo.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (photo == other).should be_false
    end
    it "should return false when ids are not equal" do
      photo = Twitter::Photo.new('id' => 1)
      other = Twitter::Photo.new('id' => 2)
      (photo == other).should be_false
    end
  end

  describe "#sizes" do
    it "should return a hash of Sizes when sizes is set" do
      sizes = Twitter::Photo.new('sizes' => {'small' => {'h' => 226, 'w' => 340, 'resize' => 'fit'}, 'large' => {'h' => 466, 'w' => 700, 'resize' => 'fit'}, 'medium' => {'h' => 399, 'w' => 600, 'resize' => 'fit'}, 'thumb' => {'h' => 150, 'w' => 150, 'resize' => 'crop'}}).sizes
      sizes.should be_a Hash
      sizes['small'].should be_a Twitter::Size
    end
    it "should be empty when sizes is not set" do
      sizes = Twitter::Photo.new.sizes
      sizes.should be_empty
    end
  end

end
