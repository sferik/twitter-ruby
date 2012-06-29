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
    it "returns false for empty objects" do
      status = Twitter::Status.new
      other = Twitter::Status.new
      (status == other).should be_false
    end
    it "returns true when objects IDs are the same" do
      status = Twitter::Status.new(:id => 1, :text => "foo")
      other = Twitter::Status.new(:id => 1, :text => "bar")
      (status == other).should be_true
    end
    it "returns false when objects IDs are different" do
      status = Twitter::Status.new(:id => 1)
      other = Twitter::Status.new(:id => 2)
      (status == other).should be_false
    end
    it "returns false when classes are different" do
      status = Twitter::Status.new(:id => 1)
      other = Twitter::Identifiable.new(:id => 1)
      (status == other).should be_false
    end
    it "returns true when objects non-ID attributes are the same" do
      status = Twitter::Status.new(:text => "foo")
      other = Twitter::Status.new(:text => "foo")
      (status == other).should be_true
    end
    it "returns false when objects non-ID attributes are different" do
      status = Twitter::Status.new(:text => "foo")
      other = Twitter::Status.new(:text => "bar")
      (status == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when set" do
      status = Twitter::Status.new(:created_at => "Mon Jul 16 12:59:01 +0000 2007")
      status.created_at.should be_a Time
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.created_at.should be_nil
    end
  end

  describe "#favoriters_count" do
    it "returns the count of favoriters when favoriters_count is set" do
      status = Twitter::Status.new(:favoriters_count => '1')
      status.favoriters_count.should be_an Integer
      status.favoriters_count.should eq 1
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.favoriters_count.should be_nil
    end
  end

  describe "#from_user" do
    it "returns a screen name when from_user is set" do
      status = Twitter::Status.new(:from_user => 'sferik')
      status.from_user.should be_a String
      status.from_user.should eq "sferik"
    end
    it "returns a screen name when screen_name is set" do
      status = Twitter::Status.new(:user => {:screen_name => 'sferik'})
      status.from_user.should be_a String
      status.from_user.should eq "sferik"
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.from_user.should be_nil
    end
  end

  describe "#full_text" do
    it "returns the text of a status" do
      status = Twitter::Status.new(:text => 'BOOSH')
      status.full_text.should be_a String
      status.full_text.should eq "BOOSH"
    end
    it "returns the text of a status without a user" do
      status = Twitter::Status.new(:text => 'BOOSH', :retweeted_status => {:text => 'BOOSH'})
      status.full_text.should be_a String
      status.full_text.should eq "BOOSH"
    end
    it "returns the full text of a retweeted status" do
      status = Twitter::Status.new(:retweeted_status => {:text => 'BOOSH', :user => {:screen_name => 'sferik'}})
      status.full_text.should be_a String
      status.full_text.should eq "RT @sferik: BOOSH"
    end
    it "returns nil when retweeted_status is not set" do
      status = Twitter::Status.new
      status.full_text.should be_nil
    end
  end

  describe "#geo" do
    it "returns a Twitter::Point when set" do
      status = Twitter::Status.new(:geo => {:type => 'Point'})
      status.geo.should be_a Twitter::Point
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.geo.should be_nil
    end
  end

  describe "#hashtags" do
    it "returns an Array of Entity::Hashtag when entities are set" do
      hashtags_hash = [
        {
          :text => 'twitter',
          :indices => [10, 33],
        }
      ]
      hashtags = Twitter::Status.new(:entities => {:hashtags => hashtags_hash}).hashtags
      hashtags.should be_an Array
      hashtags.first.should be_a Twitter::Entity::Hashtag
      hashtags.first.indices.should eq [10, 33]
      hashtags.first.text.should eq 'twitter'
    end
    it "returns nil when not set" do
      hashtags = Twitter::Status.new.hashtags
      hashtags.should be_nil
    end
    it "warns when not set" do
      Twitter::Status.new.hashtags
      $stderr.string.should =~ /To get hashtags, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#media" do
    it "returns media" do
      media = Twitter::Status.new(:entities => {:media => [{:type => 'photo'}]}).media
      media.should be_an Array
      media.first.should be_a Twitter::Photo
    end
    it "returns nil when not set" do
      media = Twitter::Status.new.media
      media.should be_nil
    end
    it "warns when not set" do
      Twitter::Status.new.media
      $stderr.string.should =~ /To get media, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#metadata" do
    it "returns a User when user is set" do
      metadata = Twitter::Status.new(:metadata => {}).metadata
      metadata.should be_a Twitter::Metadata
    end
    it "returns nil when user is not set" do
      metadata = Twitter::Status.new.metadata
      metadata.should be_nil
    end
  end

  describe "#oembed" do
    before do
      stub_get("/1/statuses/oembed.json?id=25938088801").
        to_return(:body => fixture("oembed.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      @status = Twitter::Status.new(:id => 25938088801)
    end
    it "requests the correct resource" do
      @status.oembed
      a_get("/1/statuses/oembed.json?id=25938088801").
        should have_been_made
    end
    it "returns an OEmbed instance" do
      oembed = @status.oembed
      oembed.should be_a Twitter::OEmbed
    end
    context "without an id" do
      it "returns nil" do
        status = Twitter::Status.new
        status.oembed.should be_nil
      end
    end
  end

  describe "#place" do
    it "returns a Twitter::Place when set" do
      status = Twitter::Status.new(:place => {})
      status.place.should be_a Twitter::Place
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.place.should be_nil
    end
  end

  describe "#repliers_count" do
    it "returns the count of favoriters when repliers_count is set" do
      status = Twitter::Status.new(:repliers_count => '1')
      status.repliers_count.should be_an Integer
      status.repliers_count.should eq 1
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.repliers_count.should be_nil
    end
  end

  describe "#retweeters_count" do
    it "returns the count of favoriters when retweet_count is set" do
      status = Twitter::Status.new(:retweet_count => '1')
      status.retweeters_count.should be_an Integer
      status.retweeters_count.should eq 1
    end
    it "returns the count of favoriters when retweeters_count is set" do
      status = Twitter::Status.new(:retweeters_count => '1')
      status.retweeters_count.should be_an Integer
      status.retweeters_count.should eq 1
    end
    it "returns nil when not set" do
      status = Twitter::Status.new
      status.retweeters_count.should be_nil
    end
  end

  describe "#retweeted_status" do
    it "returns a Status when retweeted_status is set" do
      status = Twitter::Status.new(:retweeted_status => {:text => 'BOOSH'})
      status.retweeted_status.should be_a Twitter::Status
    end
    it "returns nil when retweeted_status is not set" do
      status = Twitter::Status.new
      status.retweeted_status.should be_nil
    end
    it "has text when retweeted_status is set" do
      status = Twitter::Status.new(:retweeted_status => {:text => 'BOOSH'})
      status.retweeted_status.text.should eq 'BOOSH'
    end
  end

  describe "#urls" do
    it "returns an Array of Entity::Url when entities are set" do
      urls_hash = [
        {
          :url => 'http://example.com/t.co',
          :expanded_url => 'http://example.com/expanded',
          :display_url => 'example.com/expanded',
          :indices => [10, 33],
        }
      ]
      urls = Twitter::Status.new(:entities => {:urls => urls_hash}).urls
      urls.should be_an Array
      urls.first.should be_a Twitter::Entity::Url
      urls.first.indices.should eq [10, 33]
      urls.first.display_url.should eq 'example.com/expanded'
    end
    it "returns nil when not set" do
      urls = Twitter::Status.new.urls
      urls.should be_nil
    end
    it "warns when not set" do
      Twitter::Status.new.urls
      $stderr.string.should =~ /To get URLs, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      user = Twitter::Status.new(:user => {}).user
      user.should be_a Twitter::User
    end
    it "returns nil when user is not set" do
      user = Twitter::Status.new.user
      user.should be_nil
    end
    it "has a status when status is set" do
      user = Twitter::Status.new(:text => 'Tweet text.', :user => {}).user
      user.status.should be_a Twitter::Status
      user.status.text.should eq 'Tweet text.'
    end
  end

  describe "#user_mentions" do
    it "returns an Array of Entity::UserMention when entities are set" do
      user_mentions_hash = [
        {
          :screen_name => 'sferik',
          :name => 'Erik Michaels-Ober',
          :id_str => '7505382',
          :indices => [0, 6],
          :id => 7505382,
        }
      ]
      user_mentions = Twitter::Status.new(:entities => {:user_mentions => user_mentions_hash}).user_mentions
      user_mentions.should be_an Array
      user_mentions.first.should be_a Twitter::Entity::UserMention
      user_mentions.first.indices.should eq [0, 6]
      user_mentions.first.screen_name.should eq 'sferik'
    end
    it "returns nil when not set" do
      user_mentions = Twitter::Status.new.user_mentions
      user_mentions.should be_nil
    end
    it "warns when not set" do
      Twitter::Status.new.user_mentions
      $stderr.string.should =~ /To get user mentions, you must pass `:include_entities => true` when requesting the Twitter::Status\./
    end
  end

end
