require 'helper'

describe Twitter::List do

  describe "#==" do
    it "returns true when ids and classes are equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::List.new('id' => 1)
      (list == other).should be_true
    end
    it "returns false when classes are not equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (list == other).should be_false
    end
    it "returns false when ids are not equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::List.new('id' => 2)
      (list == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::List.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::List.new
      user.created_at.should be_nil
    end
  end

  describe "#user" do
    it "returns a User when user is set" do
      user = Twitter::List.new('user' => {}).user
      user.should be_a Twitter::User
    end
    it "returns nil when status is not set" do
      user = Twitter::List.new.user
      user.should be_nil
    end
  end

end
