require 'helper'

describe Twitter::Action do

  describe "#created_at" do
    it "returns a Time when created_at is set" do
      user = Twitter::User.new(:id => 7505382, :created_at => "Mon Jul 16 12:59:01 +0000 2007")
      expect(user.created_at).to be_a Time
    end
    it "returns nil when created_at is not set" do
      user = Twitter::User.new(:id => 7505382)
      expect(user.created_at).to be_nil
    end
  end

end
