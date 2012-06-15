require 'helper'

describe Twitter::OEmbed do
  describe "#author_url" do
    it "returns the author's url" do
      oembed = Twitter::OEmbed.new('author_url' => 'https://twitter.com/sferik')
      oembed.author_url.should == "https://twitter.com/sferik"
    end

    it "returns nil when not set" do
      author_url = Twitter::OEmbed.new.author_url
      author_url.should be_nil
    end
  end

  describe "#author_name" do
    it "returns the author's name" do
      oembed = Twitter::OEmbed.new('author_name' => 'Erik Michaels-Ober')
      oembed.author_name.should == "Erik Michaels-Ober"
    end

    it "returns nil when not set" do
      author_name = Twitter::OEmbed.new.author_name
      author_name.should be_nil
    end
  end

  describe "#cache_age" do
    it "returns the cache_age" do
      oembed = Twitter::OEmbed.new('cache_age' => '31536000000')
      oembed.cache_age.should == "31536000000"
    end

    it "returns nil when not set" do
      cache_age = Twitter::OEmbed.new.cache_age
      cache_age.should be_nil
    end
  end

  describe "#height" do
    it "returns the height" do
      oembed = Twitter::OEmbed.new('height' => 200)
      oembed.height.should == 200
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new('height' => 200)
      oembed.height.should be_an Integer
    end

    it "returns nil when not set" do
      height = Twitter::OEmbed.new.height
      height.should be_nil
    end
  end

  describe "#html" do
    it "returns the html" do
      oembed = Twitter::OEmbed.new('html' => '<blockquote>all my <b>witty tweet</b> stuff here</blockquote>')
      oembed.html.should == "<blockquote>all my <b>witty tweet</b> stuff here</blockquote>"
    end

    it "returns nil when not set" do
      html = Twitter::OEmbed.new.html
      html.should be_nil
    end
  end

  describe "#provider_name" do
    it "returns the provider_name" do
      oembed = Twitter::OEmbed.new('provider_name' => 'Twitter')
      oembed.provider_name.should == "Twitter"
    end

    it "returns nil when not set" do
      provider_name = Twitter::OEmbed.new.provider_name
      provider_name.should be_nil
    end
  end

  describe "#provider_url" do
    it "returns the provider_url" do
      oembed = Twitter::OEmbed.new('provider_url' => 'http://twitter.com')
      oembed.provider_url.should == "http://twitter.com"
    end

    it "returns nil when not set" do
      provider_url = Twitter::OEmbed.new.provider_url
      provider_url.should be_nil
    end
  end

  describe "#type" do
    it "returns the type" do
      oembed = Twitter::OEmbed.new('type' => 'rich')
      oembed.type.should == "rich"
    end

    it "returns nil when not set" do
      type = Twitter::OEmbed.new.type
      type.should be_nil
    end
  end

  describe "#width" do
    it "returns the width" do
      oembed = Twitter::OEmbed.new('width' => 550)
      oembed.width.should == 550
    end

    it "returns it as an Integer" do
      oembed = Twitter::OEmbed.new('width' => 550)
      oembed.width.should be_an Integer
    end

    it "returns nil when not set" do
      width = Twitter::OEmbed.new.width
      width.should be_nil
    end
  end

  describe "#url" do
    it "returns the url" do
      oembed = Twitter::OEmbed.new('url' => 'https://twitter.com/twitterapi/status/133640144317198338')
      oembed.url.should == "https://twitter.com/twitterapi/status/133640144317198338"
    end

    it "returns nil when not set" do
      url = Twitter::OEmbed.new.url
      url.should be_nil
    end
  end

  describe "#version" do
    it "returns the version" do
      oembed = Twitter::OEmbed.new('version' => '1.0')
      oembed.version.should == "1.0"
    end

    it "returns nil when not set" do
      version = Twitter::OEmbed.new.version
      version.should be_nil
    end
  end
end
