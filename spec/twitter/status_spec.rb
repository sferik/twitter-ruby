require 'helper'

describe Twitter::Status do

  before do
    @old_stderr = $stderr
    $stderr = StringIO.new
  end

  after do
    $stderr = @old_stderr
  end

  describe "#==" do
    it "should return true when ids and classes are equal" do
      status = Twitter::Status.new('id' => 1)
      other = Twitter::Status.new('id' => 1)
      (status == other).should be_true
    end
    it "should return false when classes are not equal" do
      status = Twitter::Status.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (status == other).should be_false
    end
    it "should return false when ids are not equal" do
      status = Twitter::Status.new('id' => 1)
      other = Twitter::Status.new('id' => 2)
      (status == other).should be_false
    end
  end

  describe "#created_at" do
    it "should return a Time when set" do
      status = Twitter::Status.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      status.created_at.should be_a Time
    end
    it "should return nil when not set" do
      status = Twitter::Status.new
      status.created_at.should be_nil
    end
  end

  describe "#expanded_urls" do
    it "should return the expanded urls" do
      urls = [{'expanded_url' => 'http://example.com'}]
      expanded_urls = Twitter::Status.new('entities' => {'urls' => urls}).expanded_urls
      expanded_urls.should be_an Array
      expanded_urls.first.should == "http://example.com"
    end
    it "should return nil when not set" do
      expanded_urls = Twitter::Status.new.expanded_urls
      expanded_urls.should be_nil
    end
    it "should warn when not set" do
      Twitter::Status.new.expanded_urls
      $stderr.string.should =~ /\[DEPRECATION\] Twitter::Status#expanded_urls it deprecated\. Use Twitter::Status#urls instead\./
    end
  end

  describe "#geo" do
    it "should return a Twitter::Point when set" do
      status = Twitter::Status.new('geo' => {'type' => 'Point'})
      status.geo.should be_a Twitter::Point
    end
    it "should return nil when not set" do
      status = Twitter::Status.new
      status.geo.should be_nil
    end
  end

  describe "#hashtags" do
    it "should return an Array of Entity::Hashtag when entities are set" do
      hashtags_hash = [{'text' => 'twitter',
          'indices' => [10, 33]}]
      hashtags = Twitter::Status.new('entities' => {'hashtags' => hashtags_hash}).hashtags
      hashtags.should be_an Array
      hashtags.first.should be_an Twitter::Entity::Hashtag
      hashtags.first.indices.should == [10, 33]
      hashtags.first.text.should == 'twitter'
    end
    it "should return nil when not set" do
      hashtags = Twitter::Status.new.hashtags
      hashtags.should be_nil
    end
    it "should warn when not set" do
      Twitter::Status.new.hashtags
      $stderr.string.should =~ /To get hashtags, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#media" do
    it "should return media" do
      media = Twitter::Status.new('entities' => {'media' => [{'type' => 'photo'}]}).media
      media.should be_an Array
      media.first.should be_a Twitter::Photo
    end
    it "should return nil when not set" do
      media = Twitter::Status.new.media
      media.should be_nil
    end
    it "should warn when not set" do
      Twitter::Status.new.media
      $stderr.string.should =~ /To get media, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#metadata" do
    it "should return a User when user is set" do
      metadata = Twitter::Status.new('metadata' => {}).metadata
      metadata.should be_a Twitter::Metadata
    end
    it "should return nil when user is not set" do
      metadata = Twitter::Status.new.metadata
      metadata.should be_nil
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1/statuses/oembed.json?id=25938088801").
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @status = Twitter::Status.new('id' => 25938088801)
    end
    it "should request the correct resource" do
      @status.oembed
      a_get("/1/statuses/oembed.json?id=25938088801").
        should have_been_made
    end
    it "should return an OEmbed instance" do
      oembed = @status.oembed
      oembed.should be_a Twitter::OEmbed
    end
    context "without an id" do
      it "should return nil" do
        status = Twitter::Status.new
        status.oembed.should be_nil
      end
    end
  end

  describe "#place" do
    it "should return a Twitter::Place when set" do
      status = Twitter::Status.new('place' => {})
      status.place.should be_a Twitter::Place
    end
    it "should return nil when not set" do
      status = Twitter::Status.new
      status.place.should be_nil
    end
  end

  describe "#retweeted_status" do
    before do
      @a_retweeted_status = Twitter::Status.new('retweeted_status' => {'text' => 'BOOSH'})
    end
    it "should return a Status when retweeted_status is set" do
      @a_retweeted_status.retweeted_status.should be_a Twitter::Status
    end
    it "should return nil when a retweeted_status is NOT set" do
      status = Twitter::Status.new
      status.retweeted_status.should be_nil
    end
    it "should have text when retweeted_status is set" do
      status = Twitter::Status.new('retweeted_status' => {'text' => 'BOOSH'})
      status.retweeted_status.text.should == 'BOOSH'
    end
  end

  describe "#urls" do
    it "should return an Array of Entity::Url when entities are set" do
      urls_hash = [{'url' => 'http://example.com/t.co',
          'expanded_url' => 'http://example.com/expanded',
          'display_url' => 'example.com/expanded',
          'indices' => [10, 33]}]
      urls = Twitter::Status.new('entities' => {'urls' => urls_hash}).urls
      urls.should be_an Array
      urls.first.should be_an Twitter::Entity::Url
      urls.first.indices.should == [10, 33]
      urls.first.display_url.should == 'example.com/expanded'
    end
    it "should return nil when not set" do
      urls = Twitter::Status.new.urls
      urls.should be_nil
    end
    it "should warn when not set" do
      Twitter::Status.new.urls
      $stderr.string.should =~ /To get URLs, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#user" do
    it "should return a User when user is set" do
      user = Twitter::Status.new('user' => {}).user
      user.should be_a Twitter::User
    end
    it "should return nil when user is not set" do
      user = Twitter::Status.new.user
      user.should be_nil
    end
    it "should have a status when status is set" do
      user = Twitter::Status.new('text' => 'Tweet text.', 'user' => {}).user
      user.status.should be_a Twitter::Status
      user.status.text.should == 'Tweet text.'
    end
  end

  describe "#user_mentions" do
    it "should return an Array of Entity::User_Mention when entities are set" do
      user_mentions_hash = [{'screen_name'=>'sferik',
          'name'=>'Erik Michaels-Ober',
          'id_str'=>'7505382',
          'indices'=>[0, 6],
          'id'=>7505382}]
      user_mentions = Twitter::Status.new('entities' => {'user_mentions' => user_mentions_hash}).user_mentions
      user_mentions.should be_an Array
      user_mentions.first.should be_an Twitter::Entity::UserMention
      user_mentions.first.indices.should == [0, 6]
      user_mentions.first.screen_name.should == 'sferik'
    end
    it "should return nil when not set" do
      user_mentions = Twitter::Status.new.user_mentions
      user_mentions.should be_nil
    end
    it "should warn when not set" do
      Twitter::Status.new.user_mentions
      $stderr.string.should =~ /To get user mentions, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

end
