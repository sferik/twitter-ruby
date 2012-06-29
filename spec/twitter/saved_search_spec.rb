require 'helper'

describe Twitter::SavedSearch do

  describe "#==" do
    it "returns false for empty objects" do
      saved_search = Twitter::SavedSearch.new
      other = Twitter::SavedSearch.new
      (saved_search == other).should be_false
    end
    it "returns true when objects IDs are the same" do
      saved_search = Twitter::SavedSearch.new(:id => 1, :name => "foo")
      other = Twitter::SavedSearch.new(:id => 1, :name => "bar")
      (saved_search == other).should be_true
    end
    it "returns false when objects IDs are different" do
      saved_search = Twitter::SavedSearch.new(:id => 1)
      other = Twitter::SavedSearch.new(:id => 2)
      (saved_search == other).should be_false
    end
    it "returns false when classes are different" do
      saved_search = Twitter::SavedSearch.new(:id => 1)
      other = Twitter::Identifiable.new(:id => 1)
      (saved_search == other).should be_false
    end
    it "returns true when objects non-ID attributes are the same" do
      saved_search = Twitter::SavedSearch.new(:name => "foo")
      other = Twitter::SavedSearch.new(:name => "foo")
      (saved_search == other).should be_true
    end
    it "returns false when objects non-ID attributes are different" do
      saved_search = Twitter::SavedSearch.new(:name => "foo")
      other = Twitter::SavedSearch.new(:name => "bar")
      (saved_search == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      saved_search = Twitter::SavedSearch.new(:created_at => "Mon Jul 16 12:59:01 +0000 2007")
      saved_search.created_at.should be_a Time
    end
    it "returns nil when created_at is not set" do
      saved_search = Twitter::SavedSearch.new
      saved_search.created_at.should be_nil
    end
  end

end
