require 'helper'

describe Twitter::Action::Favorite do

  describe "#sources" do
    it "returns a collection of users who favorited a Tweet" do
      sources = Twitter::Action::Favorite.new(:sources => [{:id => 7505382}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Favorite.new.sources
      sources.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the favorited Tweet" do
      targets = Twitter::Action::Favorite.new(:targets => [{:id => 25938088801}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::Tweet
    end
    it "is empty when not set" do
      targets = Twitter::Action::Favorite.new.targets
      targets.should be_empty
    end
  end

end
