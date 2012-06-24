require 'helper'

describe Twitter::Action::Mention do

  describe "#sources" do
    it "returns a collection of users who mentioned a user" do
      sources = Twitter::Action::Mention.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Mention.new.sources
      sources.should be_empty
    end
  end

  describe "#source" do
    it "returns the user who mentioned a user" do
      source = Twitter::Action::Mention.new(:sources => [{}]).source
      source.should be_a Twitter::User
    end
    it "returns nil when not set" do
      source = Twitter::Action::Mention.new.source
      source.should be_nil
    end
  end

  describe "#target_objects" do
    it "returns a collection of statuses that mention a user" do
      targets = Twitter::Action::Mention.new(:target_objects => [{}]).target_objects
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      targets = Twitter::Action::Mention.new.target_objects
      targets.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the mentioned user" do
      targets = Twitter::Action::Mention.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::Mention.new.targets
      targets.should be_empty
    end
  end

end
