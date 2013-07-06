require 'helper'

describe Twitter::Configuration do

  describe "#photo_sizes" do
    it "returns a hash of sizes when photo_sizes is set" do
      photo_sizes = Twitter::Configuration.new(:photo_sizes => {:small => {:h => 226, :w => 340, :resize => 'fit'}, :large => {:h => 466, :w => 700, :resize => 'fit'}, :medium => {:h => 399, :w => 600, :resize => 'fit'}, :thumb => {:h => 150, :w => 150, :resize => 'crop'}}).photo_sizes
      expect(photo_sizes).to be_a Hash
      expect(photo_sizes[:small]).to be_a Twitter::Size
    end
    it "is empty when photo_sizes is not set" do
      photo_sizes = Twitter::Configuration.new.photo_sizes
      expect(photo_sizes).to be_empty
    end
  end

end
