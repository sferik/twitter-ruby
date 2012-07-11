require 'helper'

describe Twitter::MediaFactory do

  describe ".new" do
    it "generates a Photo" do
      media = Twitter::MediaFactory.fetch_or_create(:id => 1, :type => 'photo')
      media.should be_a Twitter::Photo
    end
    it "raises an ArgumentError when type is not specified" do
      lambda do
        Twitter::MediaFactory.fetch_or_create
      end.should raise_error(ArgumentError, "argument must have a :type key")
    end
  end

end
