require "test_helper"

describe Twitter::Media::Video do
  media_object_examples(klass: Twitter::Media::Video)

  describe "#video_info" do
    it "returns a Twitter::Media::VideoInfo when the video is set" do
      video = Twitter::Media::Video.new(id: 1, video_info: {})

      assert_kind_of(Twitter::Media::VideoInfo, video.video_info)
    end

    it "returns nil when the display_url is not set" do
      video = Twitter::Media::Video.new(id: 1, video_info: nil)

      assert_nil(video.video_info)
    end
  end

  describe "#type" do
    it "returns true when the type is set" do
      video = Twitter::Media::Video.new(id: 1, type: "video")

      assert_equal("video", video.type)
    end

    it "returns false when the type is not set" do
      video = Twitter::Media::Video.new(id: 1)

      assert_nil(video.type)
    end
  end
end
