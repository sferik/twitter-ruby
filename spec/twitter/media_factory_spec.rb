require 'helper'

describe Twitter::MediaFactory do

  describe ".new" do
    it "generates a Photo" do
      media = Twitter::MediaFactory.new('type' => 'photo')
      media.should be_a Twitter::Photo
    end
    it "raises an ArgumentError when type is not specified" do
      lambda do
        Twitter::MediaFactory.new({})
      end.should raise_error(ArgumentError, "argument must have a 'type' key")
    end
  end

end
