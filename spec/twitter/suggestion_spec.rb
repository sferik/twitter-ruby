require 'helper'

describe Twitter::Suggestion do

  describe "#==" do
    it "returns false for empty objects" do
      suggestion = Twitter::Suggestion.new
      other = Twitter::Suggestion.new
      (suggestion == other).should be_false
    end
    it "returns true when objects slugs are the same" do
      suggestion = Twitter::Suggestion.new(:slug => 1, :name => "foo")
      other = Twitter::Suggestion.new(:slug => 1, :name => "bar")
      (suggestion == other).should be_true
    end
    it "returns false when objects slugs are different" do
      suggestion = Twitter::Suggestion.new(:slug => 1)
      other = Twitter::Suggestion.new(:slug => 2)
      (suggestion == other).should be_false
    end
    it "returns false when classes are different" do
      suggestion = Twitter::Suggestion.new(:slug => 1)
      other = Twitter::Base.new(:slug => 1)
      (suggestion == other).should be_false
    end
    it "returns true when objects non-slug attributes are the same" do
      suggestion = Twitter::Suggestion.new(:name => "foo")
      other = Twitter::Suggestion.new(:name => "foo")
      (suggestion == other).should be_true
    end
    it "returns false when objects non-slug attributes are different" do
      suggestion = Twitter::Suggestion.new(:name => "foo")
      other = Twitter::Suggestion.new(:name => "bar")
      (suggestion == other).should be_false
    end
  end

  describe "#users" do
    it "returns a User when user is set" do
      users = Twitter::Suggestion.new(:users => [:user => {}]).users
      users.should be_an Array
      users.first.should be_a Twitter::User
    end
    it "returns nil when status is not set" do
      users = Twitter::Suggestion.new.users
      users.should be_nil
    end
  end

end
