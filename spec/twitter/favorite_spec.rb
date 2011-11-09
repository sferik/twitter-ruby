require 'helper'

describe Twitter::Favorite do

  describe "#sources" do
    it "should return a collection of users who favorited a status" do
      sources = Twitter::Favorite.new('sources' => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "should be empty when not set" do
      sources = Twitter::Favorite.new.sources
      sources.should be_empty
    end
  end

  describe "#targets" do
    it "should return a collection containing the favorited status" do
      targets = Twitter::Favorite.new('targets' => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "should be empty when not set" do
      targets = Twitter::Favorite.new.targets
      targets.should be_empty
    end
  end

end
