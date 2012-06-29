require 'helper'

describe Twitter::DirectMessage do

  describe "#==" do
    it "returns false for empty objects" do
      direct_message = Twitter::DirectMessage.new
      other = Twitter::DirectMessage.new
      (direct_message == other).should be_false
    end
    it "returns true when objects IDs are the same" do
      direct_message = Twitter::DirectMessage.new(:id => 1, :text => "foo")
      other = Twitter::DirectMessage.new(:id => 1, :text => "bar")
      (direct_message == other).should be_true
    end
    it "returns false when objects IDs are different" do
      direct_message = Twitter::DirectMessage.new(:id => 1)
      other = Twitter::DirectMessage.new(:id => 2)
      (direct_message == other).should be_false
    end
    it "returns false when classes are different" do
      direct_message = Twitter::DirectMessage.new(:id => 1)
      other = Twitter::Identifiable.new(:id => 1)
      (direct_message == other).should be_false
    end
    it "returns true when objects non-ID attributes are the same" do
      direct_message = Twitter::DirectMessage.new(:text => "foo")
      other = Twitter::DirectMessage.new(:text => "foo")
      (direct_message == other).should be_true
    end
    it "returns false when objects non-ID attributes are different" do
      direct_message = Twitter::DirectMessage.new(:text => "foo")
      other = Twitter::DirectMessage.new(:text => "bar")
      (direct_message == other).should be_false
    end
  end

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      direct_message = Twitter::DirectMessage.new(:created_at => "Mon Jul 16 12:59:01 +0000 2007")
      direct_message.created_at.should be_a Time
    end
    it "returns nil when created_at is not set" do
      direct_message = Twitter::DirectMessage.new
      direct_message.created_at.should be_nil
    end
  end

  describe "#recipient" do
    it "returns a User when recipient is set" do
      recipient = Twitter::DirectMessage.new(:recipient => {}).recipient
      recipient.should be_a Twitter::User
    end
    it "returns nil when status is not set" do
      recipient = Twitter::DirectMessage.new.recipient
      recipient.should be_nil
    end
  end

  describe "#sender" do
    it "returns a User when sender is set" do
      sender = Twitter::DirectMessage.new(:sender => {}).sender
      sender.should be_a Twitter::User
    end
    it "returns nil when status is not set" do
      sender = Twitter::DirectMessage.new.sender
      sender.should be_nil
    end
  end

end
