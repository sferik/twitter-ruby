require "test_helper"

describe Twitter::Variant do
  describe "#uri" do
    it "returns a URI when the url is set" do
      variant = Twitter::Variant.new(id: 1, url: "https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4")

      assert_kind_of(Addressable::URI, variant.uri)
      assert_equal("https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4", variant.uri.to_s)
    end

    it "returns nil when the url is not set" do
      variant = Twitter::Variant.new({})

      assert_nil(variant.uri)
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      variant = Twitter::Variant.new(id: 1, url: "https://video.twimg.com/media/BQD6MPOCEAAbCH0.mp4")

      assert_predicate(variant, :uri?)
    end

    it "returns false when the url is not set" do
      variant = Twitter::Variant.new({})

      refute_predicate(variant, :uri?)
    end
  end
end
