require 'helper'

describe Twitter::MediaCreator do

  describe ".new" do
    it "generates a Photo" do
      media = Twitter::MediaCreator.new(:id => 1, :type => "photo")
      expect(media).to be_a Twitter::Media::Photo
    end
    it "raises an IndexError when type is not specified" do
      expect{Twitter::MediaCreator.new}.to raise_error IndexError
    end
  end

end
