require 'helper'

describe Twitter::List do

  describe "#==" do

    it "should return true when ids are equal" do
      direct_message = Twitter::List.new(:id => 1)
      other = Twitter::List.new(:id => 1)
      (direct_message == other).should be_true
    end

    it "should return false when ids are not equal" do
      direct_message = Twitter::List.new(:id => 1)
      other = Twitter::List.new(:id => 2)
      (direct_message == other).should be_false
    end

  end

  describe "#user" do

    it "should return a User when user is set" do
      user = Twitter::List.new(:user => {}).user
      user.should be_a Twitter::User
    end

    it "should return nil when status is not set" do
      user = Twitter::List.new.user
      user.should be_nil
    end

  end

end
