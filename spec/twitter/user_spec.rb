require 'helper'

describe Twitter::User do

  describe "#==" do
    it "returns true when ids and classes are equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (user == other).should be_true
    end
    it "returns false when classes are not equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::Status.new('id' => 1)
      (user == other).should be_false
    end
    it "returns false when ids are not equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::User.new('id' => 2)
      (user == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::User.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new
      user.created_at.should be_nil
    end
  end

  describe "#status" do
    it "returns a Status when status is set" do
      status = Twitter::User.new('status' => {}).status
      status.should be_a Twitter::Status
    end
    it "returns nil when status is not set" do
      status = Twitter::User.new.status
      status.should be_nil
    end
    it "includes a User when user is set" do
      status = Twitter::User.new('screen_name' => 'sferik', 'status' => {}).status
      status.user.should be_a Twitter::User
      status.user.screen_name.should eq 'sferik'
    end
  end

end
