require 'helper'

describe Twitter::List do

  describe "#==" do
    it "returns true when objects IDs are the same" do
      list = Twitter::List.new(:id => 1, :slug => "foo")
      other = Twitter::List.new(:id => 1, :slug => "bar")
      expect(list == other).to be_true
    end
    it "returns false when objects IDs are different" do
      list = Twitter::List.new(:id => 1)
      other = Twitter::List.new(:id => 2)
      expect(list == other).to be_false
    end
    it "returns false when classes are different" do
      list = Twitter::List.new(:id => 1)
      other = Twitter::Identity.new(:id => 1)
      expect(list == other).to be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::List.new(:id => 8863586, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      expect(user.created_at).to be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::List.new(:id => 8863586)
      expect(user.created_at).to be_nil
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      user = Twitter::List.new(:id => 8863586, :user => {:id => 7505382}).user
      expect(user).to be_a Twitter::User
    end
    it "returns nil when status is not set" do
      user = Twitter::List.new(:id => 8863586).user
      expect(user).to be_nil
    end
  end

end
