require 'helper'

describe Twitter::MediaFactory do

  describe ".new" do
    it "generates a Photo" do
      media = Twitter::MediaFactory.new(:id => 1, :type => "photo")
      expect(media).to be_a Twitter::Media::Photo
    end
    it "raises an ArgumentError when type is not specified" do
      expect{Twitter::MediaFactory.new}.to raise_error ArgumentError
    end
  end

end
