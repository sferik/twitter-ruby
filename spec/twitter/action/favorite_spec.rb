require 'helper'

describe Twitter::Action::Favorite do

  describe "#sources" do
    it "returns a collection of users who favorited a status" do
      sources = Twitter::Action::Favorite.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Favorite.new.sources
      sources.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the favorited status" do
      targets = Twitter::Action::Favorite.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      targets = Twitter::Action::Favorite.new.targets
      targets.should be_empty
    end
  end

end
