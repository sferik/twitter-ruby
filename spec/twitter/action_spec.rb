require 'helper'

describe Twitter::Action do

  describe "#created_at" do
    it "should return a String when created_at is set" do
      user = Twitter::User.new('created_at' => "Mon Jul 16 12:59:01 +0000 2007")
      user.created_at.should be_a String
    end
    it "should return nil when created_at is not set" do
      user = Twitter::User.new
      user.created_at.should be_nil
    end
  end

end
