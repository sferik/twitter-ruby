require 'helper'

describe Twitter::OEmbed do

  describe "#author_url" do
    it "returns the author's url" do
      oembed = Twitter::OEmbed.new(:author_url => 'https://twitter.com/sferik')
      expect(oembed.author_url).to eq "https://twitter.com/sferik"
    end

    it "returns nil when not set" do
      author_url = Twitter::OEmbed.new.author_url
      expect(author_url).to be_nil
    end
  end

  describe "#author_name" do
    it "returns the author's name" do
      oembed = Twitter::OEmbed.new(:author_name => 'Erik Michaels-Ober')
      expect(oembed.author_name).to eq "Erik Michaels-Ober"
    end

    it "returns nil when not set" do
      author_name = Twitter::OEmbed.new.author_name
      expect(author_name).to be_nil
    end
  end

  describe "#cache_age" do
    it "returns the cache_age" do
      oembed = Twitter::OEmbed.new(:cache_age => '31536000000')
      expect(oembed.cache_age).to eq "31536000000"
    end

    it "returns nil when not set" do
      cache_age = Twitter::OEmbed.new.cache_age
      expect(cache_age).to be_nil
    end
  end

  describe "#height" do
    it "returns the height" do
      oembed = Twitter::OEmbed.new(:height => 200)
      expect(oembed.height).to eq 200
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new(:height => 200)
      expect(oembed.height).to be_an Integer
    end

    it "returns nil when not set" do
      height = Twitter::OEmbed.new.height
      expect(height).to be_nil
    end
  end

  describe "#html" do
    it "returns the html" do
      oembed = Twitter::OEmbed.new(:html => '<blockquote>all my <b>witty tweet</b> stuff here</blockquote>')
      expect(oembed.html).to eq "<blockquote>all my <b>witty tweet</b> stuff here</blockquote>"
    end

    it "returns nil when not set" do
      html = Twitter::OEmbed.new.html
      expect(html).to be_nil
    end
  end

  describe "#provider_name" do
    it "returns the provider_name" do
      oembed = Twitter::OEmbed.new(:provider_name => 'Twitter')
      expect(oembed.provider_name).to eq "Twitter"
    end

    it "returns nil when not set" do
      provider_name = Twitter::OEmbed.new.provider_name
      expect(provider_name).to be_nil
    end
  end

  describe "#provider_url" do
    it "returns the provider_url" do
      oembed = Twitter::OEmbed.new(:provider_url => 'http://twitter.com')
      expect(oembed.provider_url).to eq "http://twitter.com"
    end

    it "returns nil when not set" do
      provider_url = Twitter::OEmbed.new.provider_url
      expect(provider_url).to be_nil
    end
  end

  describe "#type" do
    it "returns the type" do
      oembed = Twitter::OEmbed.new(:type => 'rich')
      expect(oembed.type).to eq "rich"
    end

    it "returns nil when not set" do
      type = Twitter::OEmbed.new.type
      expect(type).to be_nil
    end
  end

  describe "#width" do
    it "returns the width" do
      oembed = Twitter::OEmbed.new(:width => 550)
      expect(oembed.width).to eq 550
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new(:width => 550)
      expect(oembed.width).to be_an Integer
    end

    it "returns nil when not set" do
      width = Twitter::OEmbed.new.width
      expect(width).to be_nil
    end
  end

  describe "#url" do
    it "returns the url" do
      oembed = Twitter::OEmbed.new(:url => 'https://twitter.com/twitterapi/status/133640144317198338')
      expect(oembed.url).to eq "https://twitter.com/twitterapi/status/133640144317198338"
    end

    it "returns nil when not set" do
      url = Twitter::OEmbed.new.url
      expect(url).to be_nil
    end
  end

  describe "#version" do
    it "returns the version" do
      oembed = Twitter::OEmbed.new(:version => '1.0')
      expect(oembed.version).to eq "1.0"
    end

    it "returns nil when not set" do
      version = Twitter::OEmbed.new.version
      expect(version).to be_nil
    end
  end
end
