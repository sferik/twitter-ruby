require 'helper'

describe Twitter::Action::Reply do

  describe "#sources" do
    it "returns a collection of users who replied to a user" do
      sources = Twitter::Action::Reply.new(:sources => [{:id => 7505382}]).sources
      expect(sources).to be_an Array
      expect(sources.first).to be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Reply.new.sources
      expect(sources).to be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of Tweets that reply to a user" do
      targets = Twitter::Action::Reply.new(:target_objects => [{:id => 25938088801}]).target_objects
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::Tweet
    end
    it "is empty when not set" do
      targets = Twitter::Action::Reply.new.target_objects
      expect(targets).to be_empty
    end
  end

  describe "#targets" do
    it "returns a collection that contains the replied-to status" do
      targets = Twitter::Action::Reply.new(:targets => [{:id => 25938088801}]).targets
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::Tweet
    end
    it "is empty when not set" do
      targets = Twitter::Action::Reply.new.targets
      expect(targets).to be_empty
    end
  end

end
