require "test_helper"

describe Twitter::Entity::URI do
  describe "#display_uri" do
    it "returns a String when the display_url is set" do
      uri = Twitter::Entity::URI.new(display_url: "example.com/expanded...")

      assert_kind_of(String, uri.display_uri)
      assert_equal("example.com/expanded...", uri.display_uri)
    end

    it "returns nil when the display_url is not set" do
      uri = Twitter::Entity::URI.new

      assert_nil(uri.display_uri)
    end
  end

  describe "#display_uri?" do
    it "returns true when the display_url is set" do
      uri = Twitter::Entity::URI.new(display_url: "example.com/expanded...")

      assert_predicate(uri, :display_uri?)
    end

    it "returns false when the display_url is not set" do
      uri = Twitter::Entity::URI.new

      refute_predicate(uri, :display_uri?)
    end
  end

  describe "#expanded_uri" do
    it "returns a URI when the expanded_url is set" do
      uri = Twitter::Entity::URI.new(expanded_url: "https://github.com/sferik")

      assert_kind_of(Addressable::URI, uri.expanded_uri)
      assert_equal("https://github.com/sferik", uri.expanded_uri.to_s)
    end

    it "returns nil when the expanded_url is not set" do
      uri = Twitter::Entity::URI.new

      assert_nil(uri.expanded_uri)
    end
  end

  describe "#expanded_uri?" do
    it "returns true when the expanded_url is set" do
      uri = Twitter::Entity::URI.new(expanded_url: "https://github.com/sferik")

      assert_predicate(uri, :expanded_uri?)
    end

    it "returns false when the expanded_url is not set" do
      uri = Twitter::Entity::URI.new

      refute_predicate(uri, :expanded_uri?)
    end
  end

  describe "#uri" do
    it "returns a URI when the url is set" do
      uri = Twitter::Entity::URI.new(url: "https://github.com/sferik")

      assert_kind_of(Addressable::URI, uri.uri)
      assert_equal("https://github.com/sferik", uri.uri.to_s)
    end

    it "returns nil when the url is not set" do
      uri = Twitter::Entity::URI.new

      assert_nil(uri.uri)
    end
  end

  describe "#uri?" do
    it "returns true when the url is set" do
      uri = Twitter::Entity::URI.new(url: "https://github.com/sferik")

      assert_predicate(uri, :uri?)
    end

    it "returns false when the url is not set" do
      uri = Twitter::Entity::URI.new

      refute_predicate(uri, :uri?)
    end
  end
end
