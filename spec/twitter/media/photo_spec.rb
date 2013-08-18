require 'helper'

describe Twitter::Media::Photo do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      photo = Twitter::Media::Photo.new(:id => 1)
      other = Twitter::Media::Photo.new(:id => 1)
      expect(photo == other).to be_true
    end
    it "returns false when objects IDs are different" do
      photo = Twitter::Media::Photo.new(:id => 1)
      other = Twitter::Media::Photo.new(:id => 2)
      expect(photo == other).to be_false
    end
    it "returns false when classes are different" do
      photo = Twitter::Media::Photo.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(photo == other).to be_false
    end
  end

  describe "#sizes" do
    it "returns a hash of Sizes when sizes is set" do
      sizes = Twitter::Media::Photo.new(:id => 110102452988157952, :sizes => {:small => {:h => 226, :w => 340, :resize => "fit"}, :large => {:h => 466, :w => 700, :resize => "fit"}, :medium => {:h => 399, :w => 600, :resize => "fit"}, :thumb => {:h => 150, :w => 150, :resize => "crop"}}).sizes
      expect(sizes).to be_a Hash
      expect(sizes[:small]).to be_a Twitter::Size
    end
    it "is empty when sizes is not set" do
      sizes = Twitter::Media::Photo.new(:id => 110102452988157952).sizes
      expect(sizes).to be_empty
    end
  end

  describe "#display_uri" do
    it "returns a URI when the display_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :display_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.display_uri).to be_a URI
      expect(photo.display_uri.to_s).to eq("http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
    end
    it "returns nil when the display_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.display_uri).to be_nil
    end
  end

  describe "#display_uri?" do
    it "returns true when the display_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :display_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.display_uri).to be_true
    end
    it "returns false when the display_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.display_uri).to be_false
    end
  end

  describe "#expanded_uri" do
    it "returns a URI when the expanded_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :expanded_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.expanded_uri).to be_a URI
      expect(photo.expanded_uri.to_s).to eq("http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
    end
    it "returns nil when the expanded_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.expanded_uri).to be_nil
    end
  end

  describe "#expanded_uri?" do
    it "returns true when the expanded_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :expanded_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.expanded_uri).to be_true
    end
    it "returns false when the expanded_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.expanded_uri).to be_false
    end
  end

  describe "#media_uri" do
    it "returns a URI when the media_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :media_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.media_uri).to be_a URI
      expect(photo.media_uri.to_s).to eq("http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
    end
    it "returns nil when the media_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.media_uri).to be_nil
    end
  end

  describe "#media_uri?" do
    it "returns true when the media_url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :media_url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.media_uri).to be_true
    end
    it "returns false when the media_url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.media_uri).to be_false
    end
  end

  describe "#media_uri_https" do
    it "returns a URI when the media_url_https is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :media_url_https => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.media_uri_https).to be_a URI
      expect(photo.media_uri_https.to_s).to eq("http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
    end
    it "returns nil when the media_url_https is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.media_uri_https).to be_nil
    end
  end

  describe "#media_uri_https?" do
    it "returns true when the media_url_https is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :media_url_https => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.media_uri_https).to be_true
    end
    it "returns false when the media_url_https is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.media_uri_https).to be_false
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.uri).to be_a URI
      expect(photo.uri.to_s).to eq("http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
    end
    it "returns nil when the url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.uri).to be_nil
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      photo = Twitter::Media::Photo.new(:id => 1, :url => "http://pbs.twimg.com/media/BQD6MPOCEAAbCH0.png")
      expect(photo.uri).to be_true
    end
    it "returns false when the url is not set" do
      photo = Twitter::Media::Photo.new(:id => 1)
      expect(photo.uri).to be_false
    end
  end

end
