require "helper"

describe X::Media::Photo do
  it_behaves_like "a X::Media object"

  describe "#type" do
    it "returns true when the type is set" do
      photo = described_class.new(id: 1, type: "photo")
      expect(photo.type).to eq("photo")
    end

    it "returns false when the type is not set" do
      photo = described_class.new(id: 1)
      expect(photo.type).to be_nil
    end
  end
end
