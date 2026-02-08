require "test_helper"

describe Twitter::Media::VideoInfo do
  describe "#aspect_ratio" do
    it "returns a String when the aspect_ratio is set" do
      info = Twitter::Media::VideoInfo.new(aspect_ratio: [16, 9])

      assert_kind_of(Array, info.aspect_ratio)
      assert_equal([16, 9], info.aspect_ratio)
    end

    it "returns nil when the aspect_ratio is not set" do
      info = Twitter::Media::VideoInfo.new({})

      assert_nil(info.aspect_ratio)
    end
  end

  describe "#duration_millis" do
    it "returns a Integer when the duration_millis is set" do
      info = Twitter::Media::VideoInfo.new(duration_millis: 30_033)

      assert_kind_of(Integer, info.duration_millis)
      assert_equal(30_033, info.duration_millis)
    end

    it "returns nil when the duration_millis is not set" do
      info = Twitter::Media::VideoInfo.new({})

      assert_nil(info.duration_millis)
    end
  end

  describe "#variants" do
    it "returns a hash of Variants when variants is set" do
      variants = Twitter::Media::VideoInfo.new(variants: [{bitrate: 2_176_000, content_type: "video/mp4", url: "http://video.twimg.com/c4E56sl91ZB7cpYi.mp4"}]).variants

      assert_kind_of(Array, variants)
      assert_kind_of(Twitter::Variant, variants.first)
    end

    it "is empty when variants is not set" do
      variants = Twitter::Media::VideoInfo.new({}).variants

      assert_empty(variants)
    end
  end
end
