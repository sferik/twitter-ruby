require 'helper'

describe Twitter::Photo do

  describe "#==" do
    it "returns false for empty objects" do
      photo = Twitter::Photo.new
      other = Twitter::Photo.new
      (photo == other).should be_false
    end
    it "returns true when objects IDs are the same" do
      photo = Twitter::Photo.new(:id => 1, :url => "foo")
      other = Twitter::Photo.new(:id => 1, :url => "bar")
      (photo == other).should be_true
    end
    it "returns false when objects IDs are different" do
      photo = Twitter::Photo.new(:id => 1)
      other = Twitter::Photo.new(:id => 2)
      (photo == other).should be_false
    end
    it "returns false when classes are different" do
      photo = Twitter::Photo.new(:id => 1)
      other = Twitter::Identifiable.new(:id => 1)
      (photo == other).should be_false
    end
    it "returns true when objects non-ID attributes are the same" do
      photo = Twitter::Photo.new(:url => "foo")
      other = Twitter::Photo.new(:url => "foo")
      (photo == other).should be_true
    end
    it "returns false when objects non-ID attributes are different" do
      photo = Twitter::Photo.new(:url => "foo")
      other = Twitter::Photo.new(:url => "bar")
      (photo == other).should be_false
    end
  end

  describe "#sizes" do
    it "returns a hash of Sizes when sizes is set" do
      sizes = Twitter::Photo.new(:sizes => {:small => {:h => 226, :w => 340, :resize => 'fit'}, :large => {:h => 466, :w => 700, :resize => 'fit'}, :medium => {:h => 399, :w => 600, :resize => 'fit'}, :thumb => {:h => 150, :w => 150, :resize => 'crop'}}).sizes
      sizes.should be_a Hash
      sizes[:small].should be_a Twitter::Size
    end
    it "is empty when sizes is not set" do
      sizes = Twitter::Photo.new.sizes
      sizes.should be_empty
    end
  end

end
