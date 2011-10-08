require 'helper'

describe Twitter::User do

  describe "#created_at" do

    it "should return a Time when created_at is set" do
      user = Twitter::User.new(:created_at => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a Time
    end

    it "should return nil when created_at is not set" do
      user = Twitter::User.new
      user.created_at.should be_nil
    end

  end

  describe "#status" do
    it "should return a Status when status is set" do
      status = Twitter::User.new(:status => {:text => "Hello"}).status
      status.should be_a Twitter::Status
    end

    it "should return nil when status is not set" do
      status = Twitter::User.new.status
      status.should be_nil
    end

  end

end
