require 'helper'

describe Twitter::DirectMessage do

  describe "#==" do
    it "should return true when ids and classes are equal" do
      direct_message = Twitter::DirectMessage.new('id' => 1)
      other = Twitter::DirectMessage.new('id' => 1)
      (direct_message == other).should be_true
    end
    it "should return false when classes are not equal" do
      direct_message = Twitter::DirectMessage.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (direct_message == other).should be_false
    end
    it "should return false when ids are not equal" do
      direct_message = Twitter::DirectMessage.new('id' => 1)
      other = Twitter::DirectMessage.new('id' => 2)
      (direct_message == other).should be_false
    end
  end

  describe "#created_at" do
    it "should return a Time when created_at is set" do
      direct_message = Twitter::DirectMessage.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      direct_message.created_at.should be_a Time
    end
    it "should return nil when created_at is not set" do
      direct_message = Twitter::DirectMessage.new
      direct_message.created_at.should be_nil
    end
  end

  describe "#recipient" do
    it "should return a User when recipient is set" do
      recipient = Twitter::DirectMessage.new('recipient' => {}).recipient
      recipient.should be_a Twitter::User
    end
    it "should return nil when status is not set" do
      recipient = Twitter::DirectMessage.new.recipient
      recipient.should be_nil
    end
  end

  describe "#sender" do
    it "should return a User when sender is set" do
      sender = Twitter::DirectMessage.new('sender' => {}).sender
      sender.should be_a Twitter::User
    end
    it "should return nil when status is not set" do
      sender = Twitter::DirectMessage.new.sender
      sender.should be_nil
    end
  end

end
