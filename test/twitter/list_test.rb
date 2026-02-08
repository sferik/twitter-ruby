require "test_helper"

describe Twitter::List do
  describe "#==" do
    it "returns true when objects IDs are the same" do
      list = Twitter::List.new(id: 1, slug: "foo")
      other = Twitter::List.new(id: 1, slug: "bar")

      assert_equal(list, other)
    end

    it "returns false when objects IDs are different" do
      list = Twitter::List.new(id: 1)
      other = Twitter::List.new(id: 2)

      refute_equal(list, other)
    end

    it "returns false when classes are different" do
      list = Twitter::List.new(id: 1)
      other = Twitter::Identity.new(id: 1)

      refute_equal(list, other)
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      list = Twitter::List.new(id: 8_863_586, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_kind_of(Time, list.created_at)
      assert_predicate(list.created_at, :utc?)
    end

    it "returns nil when created_at is not set" do
      list = Twitter::List.new(id: 8_863_586)

      assert_nil(list.created_at)
    end
  end

  describe "#created?" do
    it "returns true when created_at is set" do
      list = Twitter::List.new(id: 8_863_586, created_at: "Mon Jul 16 12:59:01 +0000 2007")

      assert_predicate(list, :created?)
    end

    it "returns false when created_at is not set" do
      list = Twitter::List.new(id: 8_863_586)

      refute_predicate(list, :created?)
    end
  end

  describe "#members_uri" do
    it "returns the URI to the list members" do
      list = Twitter::List.new(id: 8_863_586, slug: "presidents", user: {id: 7_505_382, screen_name: "sferik"})

      assert_equal("https://twitter.com/sferik/presidents/members", list.members_uri.to_s)
    end

    it "returns nil when the list has no uri" do
      list = Twitter::List.new(id: 8_863_586)

      assert_nil(list.members_uri)
    end
  end

  describe "#subscribers_uri" do
    it "returns the URI to the list subscribers" do
      list = Twitter::List.new(id: 8_863_586, slug: "presidents", user: {id: 7_505_382, screen_name: "sferik"})

      assert_equal("https://twitter.com/sferik/presidents/subscribers", list.subscribers_uri.to_s)
    end

    it "returns nil when the list has no uri" do
      list = Twitter::List.new(id: 8_863_586)

      assert_nil(list.subscribers_uri)
    end
  end

  describe "#uri" do
    it "returns the URI to the list" do
      list = Twitter::List.new(id: 8_863_586, slug: "presidents", user: {id: 7_505_382, screen_name: "sferik"})

      assert_equal("https://twitter.com/sferik/presidents", list.uri.to_s)
    end

    it "returns nil when the list has no slug" do
      list = Twitter::List.new(id: 8_863_586, user: {id: 7_505_382, screen_name: "sferik"})

      assert_nil(list.uri)
    end

    it "returns nil when the list has no user screen_name" do
      list = Twitter::List.new(id: 8_863_586, slug: "presidents", user: {id: 7_505_382})

      assert_nil(list.uri)
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      list = Twitter::List.new(id: 8_863_586, user: {id: 7_505_382})

      assert_kind_of(Twitter::User, list.user)
    end

    it "returns nil when status is not set" do
      list = Twitter::List.new(id: 8_863_586)

      assert_nil(list.user)
    end
  end

  describe "#user?" do
    it "returns true when user is set" do
      list = Twitter::List.new(id: 8_863_586, user: {id: 7_505_382})

      assert_predicate(list, :user?)
    end

    it "returns false when user is not set" do
      list = Twitter::List.new(id: 8_863_586)

      refute_predicate(list, :user?)
    end
  end
end
