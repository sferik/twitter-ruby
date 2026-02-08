require "test_helper"

describe Twitter::MediaFactory do
  describe ".new" do
    it "generates a photo" do
      media = Twitter::MediaFactory.new(id: 1, type: "photo")

      assert_kind_of(Twitter::Media::Photo, media)
    end

    it "generates an animated GIF" do
      media = Twitter::MediaFactory.new(id: 1, type: "animated_gif")

      assert_kind_of(Twitter::Media::AnimatedGif, media)
    end

    it "generates a video" do
      media = Twitter::MediaFactory.new(id: 1, type: "video")

      assert_kind_of(Twitter::Media::Video, media)
    end

    it "raises an IndexError when type is not specified" do
      assert_raises(IndexError) { Twitter::MediaFactory.new }
    end
  end
end
