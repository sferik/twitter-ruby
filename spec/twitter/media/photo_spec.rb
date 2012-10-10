require 'helper'

describe Twitter::Media::Photo do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      photo = Twitter::Media::Photo.new(:id => 1, :url => "foo")
      other = Twitter::Media::Photo.new(:id => 1, :url => "bar")
      expect(photo == other).to be_true
    end
    it "returns false when objects IDs are different" do
      photo = Twitter::Media::Photo.new(:id => 1)
      other = Twitter::Media::Photo.new(:id => 2)
      expect(photo == other).to be_false
    end
    it "returns false when classes are different" do
      photo = Twitter::Media::Photo.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(photo == other).to be_false
    end
  end

  describe "#sizes" do
    it "returns a hash of Sizes when sizes is set" do
      sizes = Twitter::Media::Photo.new(:id => 110102452988157952, :sizes => {:small => {:h => 226, :w => 340, :resize => 'fit'}, :large => {:h => 466, :w => 700, :resize => 'fit'}, :medium => {:h => 399, :w => 600, :resize => 'fit'}, :thumb => {:h => 150, :w => 150, :resize => 'crop'}}).sizes
      expect(sizes).to be_a Hash
      expect(sizes[:small]).to be_a Twitter::Size
    end
    it "is empty when sizes is not set" do
      sizes = Twitter::Media::Photo.new(:id => 110102452988157952).sizes
      expect(sizes).to be_empty
    end
  end

end
