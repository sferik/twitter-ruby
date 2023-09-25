require "helper"

describe X::OEmbed do
  describe "#author_uri" do
    it "returns a URI when the author_url is set" do
      oembed = described_class.new(author_url: "https://X.com/sferik")
      expect(oembed.author_uri).to be_an Addressable::URI
      expect(oembed.author_uri.to_s).to eq("https://X.com/sferik")
    end

    it "returns nil when the author_uri is not set" do
      oembed = described_class.new
      expect(oembed.author_uri).to be_nil
    end
  end

  describe "#author_uri?" do
    it "returns true when the author_url is set" do
      oembed = described_class.new(author_url: "https://X.com/sferik")
      expect(oembed.author_uri?).to be true
    end

    it "returns false when the author_uri is not set" do
      oembed = described_class.new
      expect(oembed.author_uri?).to be false
    end
  end

  describe "#author_name" do
    it "returns the author name" do
      oembed = described_class.new(author_name: "Erik Berlin")
      expect(oembed.author_name).to eq("Erik Berlin")
    end

    it "returns nil when not set" do
      author_name = described_class.new.author_name
      expect(author_name).to be_nil
    end
  end

  describe "#cache_age" do
    it "returns the cache_age" do
      oembed = described_class.new(cache_age: "31536000000")
      expect(oembed.cache_age).to eq("31536000000")
    end

    it "returns nil when not set" do
      cache_age = described_class.new.cache_age
      expect(cache_age).to be_nil
    end
  end

  describe "#height" do
    it "returns the height" do
      oembed = described_class.new(height: 200)
      expect(oembed.height).to eq(200)
    end

    it "returns it as an Integer" do
      oembed = described_class.new(height: 200)
      expect(oembed.height).to be_an Integer
    end

    it "returns nil when not set" do
      height = described_class.new.height
      expect(height).to be_nil
    end
  end

  describe "#html" do
    it "returns the html" do
      oembed = described_class.new(html: "<blockquote>all my <b>witty tweet</b> stuff here</blockquote>")
      expect(oembed.html).to eq("<blockquote>all my <b>witty tweet</b> stuff here</blockquote>")
    end

    it "returns nil when not set" do
      html = described_class.new.html
      expect(html).to be_nil
    end
  end

  describe "#provider_name" do
    it "returns the provider_name" do
      oembed = described_class.new(provider_name: "X")
      expect(oembed.provider_name).to eq("X")
    end

    it "returns nil when not set" do
      provider_name = described_class.new.provider_name
      expect(provider_name).to be_nil
    end
  end

  describe "#provider_uri" do
    it "returns a URI when the provider_url is set" do
      oembed = described_class.new(provider_url: "http://X.com")
      expect(oembed.provider_uri).to be_an Addressable::URI
      expect(oembed.provider_uri.to_s).to eq("http://X.com")
    end

    it "returns nil when the provider_uri is not set" do
      oembed = described_class.new
      expect(oembed.provider_uri).to be_nil
    end
  end

  describe "#provider_uri?" do
    it "returns true when the provider_url is set" do
      oembed = described_class.new(provider_url: "https://X.com/sferik")
      expect(oembed.provider_uri?).to be true
    end

    it "returns false when the provider_uri is not set" do
      oembed = described_class.new
      expect(oembed.provider_uri?).to be false
    end
  end

  describe "#type" do
    it "returns the type" do
      oembed = described_class.new(type: "rich")
      expect(oembed.type).to eq("rich")
    end

    it "returns nil when not set" do
      type = described_class.new.type
      expect(type).to be_nil
    end
  end

  describe "#width" do
    it "returns the width" do
      oembed = described_class.new(width: 550)
      expect(oembed.width).to eq(550)
    end

    it "returns it as an Integer" do
      oembed = described_class.new(width: 550)
      expect(oembed.width).to be_an Integer
    end

    it "returns nil when not set" do
      width = described_class.new.width
      expect(width).to be_nil
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      oembed = described_class.new(url: "https://X.com/Xapi/status/133640144317198338")
      expect(oembed.uri).to be_an Addressable::URI
      expect(oembed.uri.to_s).to eq("https://X.com/Xapi/status/133640144317198338")
    end

    it "returns nil when the url is not set" do
      oembed = described_class.new
      expect(oembed.uri).to be_nil
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      oembed = described_class.new(url: "https://X.com/Xapi/status/133640144317198338")
      expect(oembed.uri?).to be true
    end

    it "returns false when the url is not set" do
      oembed = described_class.new
      expect(oembed.uri?).to be false
    end
  end

  describe "#version" do
    it "returns the version" do
      oembed = described_class.new(version: "1.0")
      expect(oembed.version).to eq("1.0")
    end

    it "returns nil when not set" do
      version = described_class.new.version
      expect(version).to be_nil
    end
  end
end
