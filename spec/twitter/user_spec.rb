require 'helper'

describe Twitter::User do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      user = Twitter::User.new(:id => 1, :screen_name => "foo")
      other = Twitter::User.new(:id => 1, :screen_name => "bar")
      expect(user == other).to be_true
    end
    it "returns false when objects IDs are different" do
      user = Twitter::User.new(:id => 1)
      other = Twitter::User.new(:id => 2)
      expect(user == other).to be_false
    end
    it "returns false when classes are different" do
      user = Twitter::User.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(user == other).to be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::User.new(:id => 7505382, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      expect(user.created_at).to be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.created_at).to be_nil
    end
  end

  describe "#description_urls" do
    it "returns an Array of Entity::Url" do
      urls_array = [
        {
          :url => 'http://example.com/t.co',
          :expanded_url => 'http://example.com/expanded',
          :display_url => 'example.com/expanded',
          :indices => [10, 33],
        }
      ]
      description_urls = Twitter::User.new(:id => 7505382, :entities => {:description => {:urls => urls_array}}).description_urls
      expect(description_urls).to be_an Array
      expect(description_urls.first).to be_a Twitter::Entity::Url
      expect(description_urls.first.indices).to eq [10, 33]
      expect(description_urls.first.display_url).to eq 'example.com/expanded'
    end
    it "is empty when not set" do
      description_urls = Twitter::User.new(:id => 7505382, :entities => {:description => {:urls => []}}).description_urls
      expect(description_urls).to be_empty
    end
  end

  describe "#profile_banner_url" do
    it "returns a String when profile_banner_url is set" do
      user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
      expect(user.profile_banner_url).to be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.profile_banner_url).to be_nil
    end
    it "returns the web-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
      expect(user.profile_banner_url).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/web"
    end
    context "with :web_retina passed" do
      it "returns the web retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url(:web_retina)).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/web_retina"
      end
    end
    context "with :mobile passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url(:mobile)).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/mobile"
      end
    end
    context "with :mobile_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url(:mobile_retina)).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/mobile_retina"
      end
    end
    context "with :ipad passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url(:ipad)).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/ipad"
      end
    end
    context "with :ipad_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url(:ipad_retina)).to eq "http://si0.twimg.com/profile_banners/7505382/1348266581/ipad_retina"
      end
    end
  end

  describe "#profile_banner_url_https" do
    it "returns a String when profile_banner_url is set" do
      user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
      expect(user.profile_banner_url_https).to be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.profile_banner_url_https).to be_nil
    end
    it "returns the web-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
      expect(user.profile_banner_url_https).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/web"
    end
    context "with :web_retina passed" do
      it "returns the web retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url_https(:web_retina)).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/web_retina"
      end
    end
    context "with :mobile passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url_https(:mobile)).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/mobile"
      end
    end
    context "with :mobile_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url_https(:mobile_retina)).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/mobile_retina"
      end
    end
    context "with :ipad passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url_https(:ipad)).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/ipad"
      end
    end
    context "with :ipad_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581")
        expect(user.profile_banner_url_https(:ipad_retina)).to eq "https://si0.twimg.com/profile_banners/7505382/1348266581/ipad_retina"
      end
    end
  end

  describe "#profile_banner_url?" do
    it "returns true when profile_banner_url is set" do
      profile_banner_url = Twitter::User.new(:id => 7505382, :profile_banner_url => "https://si0.twimg.com/profile_banners/7505382/1348266581").profile_banner_url?
      expect(profile_banner_url).to be_true
    end
    it "returns false when status is not set" do
      profile_banner_url = Twitter::User.new(:id => 7505382).profile_banner_url?
      expect(profile_banner_url).to be_false
    end
  end

  describe "#profile_image_url" do
    it "returns a String when profile_image_url_https is set" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      expect(user.profile_image_url).to be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.profile_image_url).to be_nil
    end
    it "returns the normal-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      expect(user.profile_image_url).to eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png"
    end
    context "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url(:original)).to eq "http://a0.twimg.com/profile_images/1759857427/image1326743606.png"
      end
    end
    context "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url(:bigger)).to eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png"
      end
    end
    context "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url(:mini)).to eq "http://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png"
      end
    end
    context "with capitalized file extension" do
      it "returns the correct image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG")
        expect(user.profile_image_url(:original)).to eq "http://si0.twimg.com/profile_images/67759670/DSCN2136.JPG"
        expect(user.profile_image_url(:bigger)).to eq "http://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG"
        expect(user.profile_image_url(:mini)).to eq "http://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG"
      end
    end
  end

  describe "#profile_image_url_https" do
    it "returns a String when profile_image_url_https is set" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      expect(user.profile_image_url_https).to be_a String
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.profile_image_url_https).to be_nil
    end
    it "returns the normal-sized image" do
      user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      expect(user.profile_image_url_https).to eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png"
    end
    context "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url_https(:original)).to eq "https://a0.twimg.com/profile_images/1759857427/image1326743606.png"
      end
    end
    context "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url_https(:bigger)).to eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png"
      end
    end
    context "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
        expect(user.profile_image_url_https(:mini)).to eq "https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png"
      end
    end
    context "with capitalized file extension" do
      it "returns the correct image" do
        user = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG")
        expect(user.profile_image_url_https(:original)).to eq "https://si0.twimg.com/profile_images/67759670/DSCN2136.JPG"
        expect(user.profile_image_url_https(:bigger)).to eq "https://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG"
        expect(user.profile_image_url_https(:mini)).to eq "https://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG"
      end
    end
  end

  describe "#profile_image_url?" do
    it "returns true when profile_banner_url is set" do
      profile_image_url = Twitter::User.new(:id => 7505382, :profile_image_url_https => "https://si0.twimg.com/profile_banners/7505382/1348266581").profile_image_url?
      expect(profile_image_url).to be_true
    end
    it "returns false when status is not set" do
      profile_image_url= Twitter::User.new(:id => 7505382).profile_image_url?
      expect(profile_image_url).to be_false
    end
  end

  describe "#status" do
    it "returns a Status when status is set" do
      tweet = Twitter::User.new(:id => 7505382, :status => {:id => 25938088801}).status
      expect(tweet).to be_a Twitter::Tweet
    end
    it "returns nil when status is not set" do
      tweet = Twitter::User.new(:id => 7505382).status
      expect(tweet).to be_nil
    end
    it "includes a User when user is set" do
      tweet = Twitter::User.new(:id => 7505382, :screen_name => 'sferik', :status => {:id => 25938088801}).status
      expect(tweet.user).to be_a Twitter::User
      expect(tweet.user.id).to eq 7505382
    end
  end

  describe "#status?" do
    it "returns true when status is set" do
      tweet = Twitter::User.new(:id => 7505382, :status => {:id => 25938088801}).status?
      expect(tweet).to be_true
    end
    it "returns false when status is not set" do
      tweet = Twitter::User.new(:id => 7505382).status?
      expect(tweet).to be_false
    end
  end

end
