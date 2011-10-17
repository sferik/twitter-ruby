require 'helper'

describe Twitter::List do

  describe "#==" do
    it "should return true when ids and classes are equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::List.new('id' => 1)
      (list == other).should be_true
    end
    it "should return false when classes are not equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::User.new('id' => 1)
      (list == other).should be_false
    end
    it "should return false when ids are not equal" do
      list = Twitter::List.new('id' => 1)
      other = Twitter::List.new('id' => 2)
      (list == other).should be_false
    end
  end

  describe "#user" do
    it "should return a User when user is set" do
      user = Twitter::List.new('user' => {}).user
      user.should be_a Twitter::User
    end
    it "should return nil when status is not set" do
      user = Twitter::List.new.user
      user.should be_nil
    end
  end

end
