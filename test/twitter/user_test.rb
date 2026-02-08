require "test_helper"

describe Twitter::User do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      user = Twitter::User.new(id: 1, screen_name: "foo")
      other = Twitter::User.new(id: 1, screen_name: "bar")

      assert_equal(user, other)
    end

    it "returns false when objects IDs are different" do
      user = Twitter::User.new(id: 1)
      other = Twitter::User.new(id: 2)

      refute_equal(user, other)
    end

    it "returns false when classes are different" do
      user = Twitter::User.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(user, other)
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::User.new(id: 7_505_382, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_kind_of(Time, user.created_at)
      assert_predicate(user.created_at, :utc?)
    end

    it "returns nil when created_at is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      user = Twitter::User.new(id: 7_505_382, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_predicate(user, :created?)
    end

    it "returns false when created_at is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :created?)
    end
  end

  describe "#description_uris" do
    it "returns an array of Entity::URIs when description URI entities are set" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})

      assert_kind_of(Array, user.description_uris)
      assert_kind_of(Twitter::Entity::URI, user.description_uris.first)
      assert_equal([10, 33], user.description_uris.first.indices)
      assert_kind_of(Addressable::URI, user.description_uris.first.expanded_uri)
    end

    it "is empty when not set" do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})

      assert_empty(user.description_uris)
    end
  end

  describe "#description_urls (alias)" do
    it "is an alias for description_uris" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})

      assert_equal(user.description_uris, user.description_urls)
    end
  end

  describe "#description_urls? (alias)" do
    it "is an alias for description_uris?" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})

      assert_equal(user.description_uris?, user.description_urls?)
    end
  end

  describe "#description_uris?" do
    it "returns true when the tweet includes description URI entities" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})

      assert_predicate(user, :description_uris?)
    end

    it "returns false when no entities are present" do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})

      refute_predicate(user, :description_uris?)
    end
  end

  describe "#entities?" do
    it "returns true if there are entities set" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [10, 33]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: urls_array}})

      assert_predicate(user, :entities?)
    end

    it "returns false if there are blank lists of entities set" do
      user = Twitter::User.new(id: 7_505_382, entities: {description: {urls: []}})

      refute_predicate(user, :entities?)
    end

    it "returns false if there are no entities set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :entities?)
    end
  end

  describe "#profile_background_image_uri" do
    it "returns the URI to the user" do
      user = Twitter::User.new(id: 7_505_382, profile_background_image_url: "http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png")

      assert_kind_of(Addressable::URI, user.profile_background_image_uri)
      assert_equal("http://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png", user.profile_background_image_uri.to_s)
    end

    it "returns nil when the screen name is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_background_image_uri)
    end
  end

  describe "#profile_background_image_uri_https" do
    it "returns the URI to the user" do
      user = Twitter::User.new(id: 7_505_382, profile_background_image_url_https: "https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png")

      assert_kind_of(Addressable::URI, user.profile_background_image_uri_https)
      assert_equal("https://pbs.twimg.com/profile_background_images/677717672/bb0b3653dcf0644e344823e0a2eb3382.png", user.profile_background_image_uri_https.to_s)
    end

    it "returns nil when the screen name is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_background_image_uri_https)
    end
  end

  describe "#profile_banner_uri" do
    it "accepts utf8 urls" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581©_normal.png")

      assert_kind_of(Addressable::URI, user.profile_banner_uri)
    end

    it "returns a URI when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_kind_of(Addressable::URI, user.profile_banner_uri)
    end

    it "returns nil when profile_banner_uri is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_banner_uri)
    end

    it "returns the web-sized image" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/web", user.profile_banner_uri.to_s)
    end

    it "does not trigger deprecated hash access internally" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      refute_match(/DEPRECATION/, capture_io { user.profile_banner_uri }.last)
    end

    it "uses hash defaults when profile_banner_url key is missing" do
      attrs = Hash.new("https://si0.twimg.com/profile_banners/default/1")
      attrs[:id] = 7_505_382
      user = Twitter::User.new(attrs)

      assert_equal("http://si0.twimg.com/profile_banners/default/1/mobile", user.profile_banner_uri(:mobile).to_s)
    end

    describe "with :web_retina passed" do
      it "returns the web retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/web_retina", user.profile_banner_uri(:web_retina).to_s)
      end
    end

    describe "with :mobile passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile", user.profile_banner_uri(:mobile).to_s)
      end
    end

    describe "with :mobile_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile_retina", user.profile_banner_uri(:mobile_retina).to_s)
      end
    end

    describe "with :ipad passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad", user.profile_banner_uri(:ipad).to_s)
      end
    end

    describe "with :ipad_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("http://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad_retina", user.profile_banner_uri(:ipad_retina).to_s)
      end
    end
  end

  describe "#profile_banner_uri_https" do
    it "accepts utf8 urls" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581©_normal.png")

      assert_kind_of(Addressable::URI, user.profile_banner_uri_https)
    end

    it "returns a URI when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_kind_of(Addressable::URI, user.profile_banner_uri_https)
    end

    it "returns nil when created_at is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_banner_uri_https)
    end

    it "returns the web-sized image" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/web", user.profile_banner_uri_https.to_s)
    end

    it "does not trigger deprecated hash access internally" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      refute_match(/DEPRECATION/, capture_io { user.profile_banner_uri_https }.last)
    end

    it "uses hash defaults when profile_banner_url key is missing" do
      attrs = Hash.new("https://si0.twimg.com/profile_banners/default/1")
      attrs[:id] = 7_505_382
      user = Twitter::User.new(attrs)

      assert_equal("https://si0.twimg.com/profile_banners/default/1/mobile", user.profile_banner_uri_https(:mobile).to_s)
    end

    describe "with :web_retina passed" do
      it "returns the web retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/web_retina", user.profile_banner_uri_https(:web_retina).to_s)
      end
    end

    describe "with :mobile passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile", user.profile_banner_uri_https(:mobile).to_s)
      end
    end

    describe "with :mobile_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/mobile_retina", user.profile_banner_uri_https(:mobile_retina).to_s)
      end
    end

    describe "with :ipad passed" do
      it "returns the mobile-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad", user.profile_banner_uri_https(:ipad).to_s)
      end
    end

    describe "with :ipad_retina passed" do
      it "returns the mobile retina-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

        assert_equal("https://si0.twimg.com/profile_banners/7_505_382/1348266581/ipad_retina", user.profile_banner_uri_https(:ipad_retina).to_s)
      end
    end
  end

  describe "#profile_banner_uri?" do
    it "returns true when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_predicate(user, :profile_banner_uri?)
    end

    it "returns false when profile_banner_url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_banner_uri?)
    end
  end

  describe "#profile_banner_url? (alias)" do
    it "returns true when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_predicate(user, :profile_banner_url?)
    end

    it "returns false when profile_banner_url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_banner_url?)
    end
  end

  describe "#profile_banner_uri_https? (alias)" do
    it "returns true when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_predicate(user, :profile_banner_uri_https?)
    end

    it "returns false when profile_banner_url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_banner_uri_https?)
    end
  end

  describe "#profile_banner_url_https? (alias)" do
    it "returns true when profile_banner_url is set" do
      user = Twitter::User.new(id: 7_505_382, profile_banner_url: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_predicate(user, :profile_banner_url_https?)
    end

    it "returns false when profile_banner_url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_banner_url_https?)
    end
  end

  describe "#profile_image_uri" do
    it "accepts utf8 urls" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/7_505_382/1348266581©_normal.png")

      assert_kind_of(Addressable::URI, user.profile_image_uri)
    end

    it "returns a URI when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      assert_kind_of(Addressable::URI, user.profile_image_uri)
    end

    it "returns nil when created_at is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_image_uri)
    end

    it "returns the normal-sized image" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      assert_equal("http://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png", user.profile_image_uri.to_s)
    end

    it "does not trigger deprecated hash access internally" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      refute_match(/DEPRECATION/, capture_io { user.profile_image_uri }.last)
    end

    describe "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("http://a0.twimg.com/profile_images/1759857427/image1326743606.png", user.profile_image_uri(:original).to_s)
      end

      it "accepts a string size and still returns the original image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("http://a0.twimg.com/profile_images/1759857427/image1326743606.png", user.profile_image_uri("original").to_s)
      end
    end

    describe "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("http://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png", user.profile_image_uri(:bigger).to_s)
      end
    end

    describe "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("http://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png", user.profile_image_uri(:mini).to_s)
      end
    end

    describe "with capitalized file extension" do
      it "returns the correct image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG")

        assert_equal("http://si0.twimg.com/profile_images/67759670/DSCN2136.JPG", user.profile_image_uri(:original).to_s)
        assert_equal("http://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG", user.profile_image_uri(:bigger).to_s)
        assert_equal("http://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG", user.profile_image_uri(:mini).to_s)
      end
    end
  end

  describe "#profile_image_uri_https" do
    it "accepts utf8 urls" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/7_505_382/1348266581©_normal.png")

      assert_kind_of(Addressable::URI, user.profile_image_uri_https)
    end

    it "returns a URI when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      assert_kind_of(Addressable::URI, user.profile_image_uri_https)
    end

    it "returns nil when created_at is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.profile_image_uri_https)
    end

    it "returns the normal-sized image" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png", user.profile_image_uri_https.to_s)
    end

    it "does not trigger deprecated hash access internally" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

      refute_match(/DEPRECATION/, capture_io { user.profile_image_uri_https }.last)
    end

    it "uses hash defaults when profile_image_url_https key is missing" do
      attrs = Hash.new("https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")
      attrs[:id] = 7_505_382
      user = Twitter::User.new(attrs)

      assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png", user.profile_image_uri_https(:bigger).to_s)
    end

    describe "with :original passed" do
      it "returns the original image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606.png", user.profile_image_uri_https(:original).to_s)
      end

      it "accepts a string size and still returns the original image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606.png", user.profile_image_uri_https("original").to_s)
      end
    end

    describe "with :bigger passed" do
      it "returns the bigger-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606_bigger.png", user.profile_image_uri_https(:bigger).to_s)
      end
    end

    describe "with :mini passed" do
      it "returns the mini-sized image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://a0.twimg.com/profile_images/1759857427/image1326743606_normal.png")

        assert_equal("https://a0.twimg.com/profile_images/1759857427/image1326743606_mini.png", user.profile_image_uri_https(:mini).to_s)
      end
    end

    describe "with capitalized file extension" do
      it "returns the correct image" do
        user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/67759670/DSCN2136_normal.JPG")

        assert_equal("https://si0.twimg.com/profile_images/67759670/DSCN2136.JPG", user.profile_image_uri_https(:original).to_s)
        assert_equal("https://si0.twimg.com/profile_images/67759670/DSCN2136_bigger.JPG", user.profile_image_uri_https(:bigger).to_s)
        assert_equal("https://si0.twimg.com/profile_images/67759670/DSCN2136_mini.JPG", user.profile_image_uri_https(:mini).to_s)
      end
    end
  end

  describe "#profile_image_uri?" do
    it "returns true when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_banners/7_505_382/1348266581")

      assert_predicate(user, :profile_image_uri?)
    end

    it "returns false when profile_image_url_https is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_image_uri?)
    end
  end

  describe "#profile_image_url? (alias)" do
    it "returns true when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/7_505_382/1348266581_normal.png")

      assert_predicate(user, :profile_image_url?)
    end

    it "returns false when profile_image_url_https is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_image_url?)
    end
  end

  describe "#profile_image_uri_https? (alias)" do
    it "returns true when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/7_505_382/1348266581_normal.png")

      assert_predicate(user, :profile_image_uri_https?)
    end

    it "returns false when profile_image_url_https is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_image_uri_https?)
    end
  end

  describe "#profile_image_url_https? (alias)" do
    it "returns true when profile_image_url_https is set" do
      user = Twitter::User.new(id: 7_505_382, profile_image_url_https: "https://si0.twimg.com/profile_images/7_505_382/1348266581_normal.png")

      assert_predicate(user, :profile_image_url_https?)
    end

    it "returns false when profile_image_url_https is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :profile_image_url_https?)
    end
  end

  describe "#insecure_uri (private)" do
    it "converts uppercase HTTPS schemes to http" do
      user = Twitter::User.new(id: 7_505_382)

      assert_equal("http://example.com/image.png", user.send(:insecure_uri, "HTTPS://example.com/image.png"))
    end

    it "uses #to_s for objects that do not implement #to_str" do
      user = Twitter::User.new(id: 7_505_382)
      uri_like = Class.new do
        def to_s
          "HTTPS://example.com/avatar.png"
        end
      end.new

      assert_equal("http://example.com/avatar.png", user.send(:insecure_uri, uri_like))
    end
  end

  describe "#status" do
    it "returns a Status when status is set" do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})

      assert_kind_of(Twitter::Tweet, user.status)
    end

    it "returns nil when status is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.status)
    end

    it "has a user" do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})

      assert_kind_of(Twitter::User, user.status.user)
      assert_equal(7_505_382, user.status.user.id)
    end
  end

  describe "#status?" do
    it "returns true when status is set" do
      user = Twitter::User.new(id: 7_505_382, status: {id: 540_897_316_908_331_009})

      assert_predicate(user, :status?)
    end

    it "returns false when status is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :status?)
    end
  end

  describe "#uri" do
    it "returns the URI to the user" do
      user = Twitter::User.new(id: 7_505_382, screen_name: "sferik")

      assert_kind_of(Addressable::URI, user.uri)
      assert_equal("https://twitter.com/sferik", user.uri.to_s)
    end

    it "returns nil when the screen name is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.uri)
    end
  end

  describe "#website" do
    it "returns a URI when the url is set" do
      user = Twitter::User.new(id: 7_505_382, url: "https://github.com/sferik")

      assert_kind_of(Addressable::URI, user.website)
      assert_equal("https://github.com/sferik", user.website.to_s)
    end

    it "returns a URI when the tweet includes website URI entities" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_kind_of(Addressable::URI, user.website)
      assert_equal("http://example.com/expanded", user.website.to_s)
    end

    it "returns nil when the url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      assert_nil(user.website)
    end
  end

  describe "#website?" do
    it "returns true when the url is set" do
      user = Twitter::User.new(id: 7_505_382, url: "https://github.com/sferik")

      assert_predicate(user, :website?)
    end

    it "returns true when the tweet includes website URI entities" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_predicate(user, :website?)
    end

    it "returns false when the url is not set" do
      user = Twitter::User.new(id: 7_505_382)

      refute_predicate(user, :website?)
    end
  end

  describe "#website_uris" do
    it "returns an array of Entity::URIs when website URI entities are set" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_kind_of(Array, user.website_uris)
      assert_kind_of(Twitter::Entity::URI, user.website_uris.first)
      assert_equal([0, 23], user.website_uris.first.indices)
      assert_kind_of(Addressable::URI, user.website_uris.first.expanded_uri)
    end

    it "is empty when not set" do
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: []}})

      assert_empty(user.website_uris)
    end
  end

  describe "#website_urls (alias)" do
    it "is an alias for website_uris" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_equal(user.website_uris, user.website_urls)
    end
  end

  describe "#website_urls? (alias)" do
    it "is an alias for website_uris?" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_equal(user.website_uris?, user.website_urls?)
    end
  end

  describe "#website_uris?" do
    it "returns true when the tweet includes website URI entities" do
      urls_array = [
        {
          url: "https://t.co/L2xIBazMPf",
          expanded_url: "http://example.com/expanded",
          display_url: "example.com/expanded...",
          indices: [0, 23]
        }
      ]
      user = Twitter::User.new(id: 7_505_382, entities: {url: {urls: urls_array}})

      assert_predicate(user, :website_uris?)
    end

    it "returns false when no entities are present" do
      user = Twitter::User.new(id: 7_505_382, entities: {})

      refute_predicate(user, :website_uris?)
    end
  end
end
