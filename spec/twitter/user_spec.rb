require 'helper'

describe Twitter::User do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      user = Twitter::User.new(:id => 1, :screen_name => "foo")
      other = Twitter::User.new(:id => 1, :screen_name => "bar")
      (user == other).should be_true
    end
    it "returns false when objects IDs are different" do
      user = Twitter::User.new(:id => 1)
      other = Twitter::User.new(:id => 2)
      (user == other).should be_false
    end
    it "returns false when classes are different" do
      user = Twitter::User.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      (user == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::User.new(:id => 7505382, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      user.created_at.should be_nil
    end
  end

  describe "#profile_image_url" do
    it "returns a String when profile_image_url is set" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url => "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      user.profile_image_url.should be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      user.profile_image_url.should be_nil
    end
    it "returns the normal-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url => "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      user.profile_image_url.should eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png"
    end
    context "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url => "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url(:original).should eq "http://a0.twimg.com/profile_images/1759857427/image1326743606.png"
      end
    end
    context "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url => "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url(:bigger).should eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png"
      end
    end
    context "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url => "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url(:mini).should eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png"
      end
    end
  end

  describe "#profile_image_url_https" do
    it "returns a String when profile_image_url_https is set" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      user.profile_image_url_https.should be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      user.profile_image_url_https.should be_nil
    end
    it "returns the normal-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      user.profile_image_url_https.should eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png"
    end
    context "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url_https(:original).should eq "https://a0.twimg.com/profile_images/1759857427/image1326743606.png"
      end
    end
    context "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url_https(:bigger).should eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png"
      end
    end
    context "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        user.profile_image_url_https(:mini).should eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png"
      end
    end
  end

  describe "#status" do
    it "returns a Status when status is set" do
      tweet = Twitter::User.new(:id => 7505382, :status => {:id => 25938088801}).status
      tweet.should be_a Twitter::Tweet
    end
    it "returns nil when status is not set" do
      tweet = Twitter::User.new(:id => 7505382).status
      tweet.should be_nil
    end
    it "includes a User when user is set" do
      tweet = Twitter::User.new(:id => 7505382, :screen_name => 'sferik', :status => {:id => 25938088801}).status
      tweet.user.should be_a Twitter::User
      tweet.user.id.should eq 7505382
    end
  end

end
