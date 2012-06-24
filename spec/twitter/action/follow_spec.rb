require 'helper'

describe Twitter::Action::Follow do

  describe "#sources" do
    it "returns a collection of users who followed a user" do
      sources = Twitter::Action::Follow.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Follow.new.sources
      sources.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the followed user" do
      targets = Twitter::Action::Follow.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::Follow.new.targets
      targets.should be_empty
    end
  end

end
