require "test_helper"

describe Twitter::OEmbed do
  describe "#author_uri" do
    it "returns a URI when the author_url is set" do
      oembed = Twitter::OEmbed.new(author_url: "https://twitter.com/sferik")

      assert_kind_of(Addressable::URI, oembed.author_uri)
      assert_equal("https://twitter.com/sferik", oembed.author_uri.to_s)
    end

    it "returns nil when the author_uri is not set" do
      oembed = Twitter::OEmbed.new

      assert_nil(oembed.author_uri)
    end
  end

  describe "#author_uri?" do
    it "returns true when the author_url is set" do
      oembed = Twitter::OEmbed.new(author_url: "https://twitter.com/sferik")

      assert_predicate(oembed, :author_uri?)
    end

    it "returns false when the author_uri is not set" do
      oembed = Twitter::OEmbed.new

      refute_predicate(oembed, :author_uri?)
    end
  end

  describe "#author_name" do
    it "returns the author name" do
      oembed = Twitter::OEmbed.new(author_name: "Erik Berlin")

      assert_equal("Erik Berlin", oembed.author_name)
    end

    it "returns nil when not set" do
      author_name = Twitter::OEmbed.new.author_name

      assert_nil(author_name)
    end
  end

  describe "#cache_age" do
    it "returns the cache_age" do
      oembed = Twitter::OEmbed.new(cache_age: "31536000000")

      assert_equal("31536000000", oembed.cache_age)
    end

    it "returns nil when not set" do
      cache_age = Twitter::OEmbed.new.cache_age

      assert_nil(cache_age)
    end
  end

  describe "#height" do
    it "returns the height" do
      oembed = Twitter::OEmbed.new(height: 200)

      assert_equal(200, oembed.height)
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new(height: 200)

      assert_kind_of(Integer, oembed.height)
    end

    it "returns nil when not set" do
      height = Twitter::OEmbed.new.height

      assert_nil(height)
    end
  end

  describe "#html" do
    it "returns the html" do
      oembed = Twitter::OEmbed.new(html: "<blockquote>all my <b>witty tweet</b> stuff here</blockquote>")

      assert_equal("<blockquote>all my <b>witty tweet</b> stuff here</blockquote>", oembed.html)
    end

    it "returns nil when not set" do
      html = Twitter::OEmbed.new.html

      assert_nil(html)
    end
  end

  describe "#provider_name" do
    it "returns the provider_name" do
      oembed = Twitter::OEmbed.new(provider_name: "Twitter")

      assert_equal("Twitter", oembed.provider_name)
    end

    it "returns nil when not set" do
      provider_name = Twitter::OEmbed.new.provider_name

      assert_nil(provider_name)
    end
  end

  describe "#provider_uri" do
    it "returns a URI when the provider_url is set" do
      oembed = Twitter::OEmbed.new(provider_url: "http://twitter.com")

      assert_kind_of(Addressable::URI, oembed.provider_uri)
      assert_equal("http://twitter.com", oembed.provider_uri.to_s)
    end

    it "returns nil when the provider_uri is not set" do
      oembed = Twitter::OEmbed.new

      assert_nil(oembed.provider_uri)
    end
  end

  describe "#provider_uri?" do
    it "returns true when the provider_url is set" do
      oembed = Twitter::OEmbed.new(provider_url: "https://twitter.com/sferik")

      assert_predicate(oembed, :provider_uri?)
    end

    it "returns false when the provider_uri is not set" do
      oembed = Twitter::OEmbed.new

      refute_predicate(oembed, :provider_uri?)
    end
  end

  describe "#type" do
    it "returns the type" do
      oembed = Twitter::OEmbed.new(type: "rich")

      assert_equal("rich", oembed.type)
    end

    it "returns nil when not set" do
      type = Twitter::OEmbed.new.type

      assert_nil(type)
    end
  end

  describe "#width" do
    it "returns the width" do
      oembed = Twitter::OEmbed.new(width: 550)

      assert_equal(550, oembed.width)
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new(width: 550)

      assert_kind_of(Integer, oembed.width)
    end

    it "returns nil when not set" do
      width = Twitter::OEmbed.new.width

      assert_nil(width)
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      oembed = Twitter::OEmbed.new(url: "https://twitter.com/twitterapi/status/133640144317198338")

      assert_kind_of(Addressable::URI, oembed.uri)
      assert_equal("https://twitter.com/twitterapi/status/133640144317198338", oembed.uri.to_s)
    end

    it "returns nil when the url is not set" do
      oembed = Twitter::OEmbed.new

      assert_nil(oembed.uri)
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      oembed = Twitter::OEmbed.new(url: "https://twitter.com/twitterapi/status/133640144317198338")

      assert_predicate(oembed, :uri?)
    end

    it "returns false when the url is not set" do
      oembed = Twitter::OEmbed.new

      refute_predicate(oembed, :uri?)
    end
  end

  describe "#version" do
    it "returns the version" do
      oembed = Twitter::OEmbed.new(version: "1.0")

      assert_equal("1.0", oembed.version)
    end

    it "returns nil when not set" do
      version = Twitter::OEmbed.new.version

      assert_nil(version)
    end
  end
end
