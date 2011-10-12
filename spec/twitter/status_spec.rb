require 'helper'

describe Twitter::Status do

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

    it "should return hashtags" do
      hashtags = Twitter::Status.new('text' => "This tweet contains a #hashtag.").hashtags
      hashtags.should be_an Array
      hashtags.first.should == "hashtag"
    end

    it "should return nil when not set" do
      hashtags = Twitter::Status.new.hashtags
      hashtags.should be_nil
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

  describe "#url" do

    it "should return urls" do
      urls = Twitter::Status.new('text' => "This tweet contains a http://example.com.").urls
      urls.should be_an Array
      urls.first.should == "http://example.com"
    end

    it "should return nil when not set" do
      urls = Twitter::Status.new.urls
      urls.should be_nil
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

  end

  describe "#user_mentions" do

    it "should return urls" do
      user_mentions = Twitter::Status.new('text' => "This tweet contains a @mention.").user_mentions
      user_mentions.should be_an Array
      user_mentions.first.should == "mention"
    end

    it "should return nil when not set" do
      user_mentions = Twitter::Status.new.user_mentions
      user_mentions.should be_nil
    end

  end

end
