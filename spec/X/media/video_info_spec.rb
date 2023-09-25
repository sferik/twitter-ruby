require "helper"

describe X::Media::VideoInfo do
  describe "#aspect_ratio" do
    it "returns a String when the aspect_ratio is set" do
      info = described_class.new(aspect_ratio: [16, 9])
      expect(info.aspect_ratio).to be_an Array
      expect(info.aspect_ratio).to eq([16, 9])
    end

    it "returns nil when the aspect_ratio is not set" do
      info = described_class.new({})
      expect(info.aspect_ratio).to be_nil
    end
  end

  describe "#duration_millis" do
    it "returns a Integer when the duration_millis is set" do
      info = described_class.new(duration_millis: 30_033)
      expect(info.duration_millis).to be_a Integer
      expect(info.duration_millis).to eq(30_033)
    end

    it "returns nil when the duration_millis is not set" do
      info = described_class.new({})
      expect(info.duration_millis).to be_nil
    end
  end

  describe "#variants" do
    it "returns a hash of Variants when variants is set" do
      variants = described_class.new(variants: [{bitrate: 2_176_000, content_type: "video/mp4", url: "http://video.twimg.com/c4E56sl91ZB7cpYi.mp4"}]).variants
      expect(variants).to be_an Array
      expect(variants.first).to be_a X::Variant
    end

    it "is empty when variants is not set" do
      variants = described_class.new({}).variants
      expect(variants).to be_empty
    end
  end
end
