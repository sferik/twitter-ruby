require "test_helper"

describe Twitter::Media::Photo do
  media_object_examples(klass: Twitter::Media::Photo)

  describe "#type" do
    it "returns true when the type is set" do
      photo = Twitter::Media::Photo.new(id: 1, type: "photo")

      assert_equal("photo", photo.type)
    end

    it "returns false when the type is not set" do
      photo = Twitter::Media::Photo.new(id: 1)

      assert_nil(photo.type)
    end
  end
end
