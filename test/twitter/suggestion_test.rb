require "test_helper"

describe Twitter::Suggestion do
  describe "#==" do
    it "returns true for empty objects" do
      suggestion = Twitter::Suggestion.new
      other = Twitter::Suggestion.new

      assert_equal(suggestion, other)
    end

    it "returns true when objects slugs are the same" do
      suggestion = Twitter::Suggestion.new(slug: 1, name: "foo")
      other = Twitter::Suggestion.new(slug: 1, name: "bar")

      assert_equal(suggestion, other)
    end

    it "returns false when objects slugs are different" do
      suggestion = Twitter::Suggestion.new(slug: 1)
      other = Twitter::Suggestion.new(slug: 2)

      refute_equal(suggestion, other)
    end

    it "returns false when classes are different" do
      suggestion = Twitter::Suggestion.new(slug: 1)
      other = Twitter::Base.new(slug: 1)

      refute_equal(suggestion, other)
    end
  end

  describe "#users" do
    it "returns a User when user is set" do
      users = Twitter::Suggestion.new(users: [{id: 7_505_382}]).users

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
    end

    it "is empty when not set" do
      users = Twitter::Suggestion.new.users

      assert_empty(users)
    end
  end
end
