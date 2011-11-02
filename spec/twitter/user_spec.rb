require 'helper'

describe Twitter::User do

  describe "#==" do
    it "should return true when ids and classes are equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (user == other).should be_true
    end
    it "should return false when classes are not equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::Status.new('id' => 1)
      (user == other).should be_false
    end
    it "should return false when ids are not equal" do
      user = Twitter::User.new('id' => 1)
      other = Twitter::User.new('id' => 2)
      (user == other).should be_false
    end
  end

  describe "#created_at" do
    it "should return a Time when created_at is set" do
      user = Twitter::User.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a Time
    end
    it "should return nil when created_at is not set" do
      user = Twitter::User.new
      user.created_at.should be_nil
    end
  end

  describe "#status" do
    it "should return a Status when status is set" do
      status = Twitter::User.new('status' => {}).status
      status.should be_a Twitter::Status
    end
    it "should return nil when status is not set" do
      status = Twitter::User.new.status
      status.should be_nil
    end
    it "should have a user when user is set" do
      status = Twitter::User.new('screen_name' => 'sferik', 'status' => {}).status
      status.user.should be_a Twitter::User
      status.user.screen_name.should == 'sferik'
    end
  end

end
