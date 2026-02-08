require "test_helper"

describe Twitter::Media::AnimatedGif do
  media_object_examples(klass: Twitter::Media::AnimatedGif)

  describe "#video_info" do
    it "returns a Twitter::Media::VideoInfo when the video is set" do
      image = Twitter::Media::AnimatedGif.new(id: 1, video_info: {})

      assert_kind_of(Twitter::Media::VideoInfo, image.video_info)
    end

    it "returns nil when the display_url is not set" do
      image = Twitter::Media::AnimatedGif.new(id: 1, video_info: nil)

      assert_nil(image.video_info)
    end
  end

  describe "#type" do
    it "returns true when the type is set" do
      image = Twitter::Media::AnimatedGif.new(id: 1, type: "animated_gif")

      assert_equal("animated_gif", image.type)
    end

    it "returns false when the type is not set" do
      image = Twitter::Media::AnimatedGif.new(id: 1)

      assert_nil(image.type)
    end
  end
end
