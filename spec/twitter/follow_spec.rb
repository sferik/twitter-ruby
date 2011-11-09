require 'helper'

describe Twitter::Follow do

  describe "#sources" do
    it "should return a collection of users who followed a user" do
      sources = Twitter::Follow.new('sources' => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "should be empty when not set" do
      sources = Twitter::Follow.new.sources
      sources.should be_empty
    end
  end

  describe "#targets" do
    it "should return a collection containing the followed user" do
      targets = Twitter::Follow.new('targets' => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "should be empty when not set" do
      targets = Twitter::Follow.new.targets
      targets.should be_empty
    end
  end

end
