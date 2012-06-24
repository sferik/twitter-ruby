require 'helper'

describe Twitter::Action::Reply do

  describe "#sources" do
    it "returns a collection of users who replied to a user" do
      sources = Twitter::Action::Reply.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Reply.new.sources
      sources.should be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of statuses that reply to a user" do
      targets = Twitter::Action::Reply.new(:target_objects => [{}]).target_objects
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      targets = Twitter::Action::Reply.new.target_objects
      targets.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection that contains the replied-to status" do
      targets = Twitter::Action::Reply.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      targets = Twitter::Action::Reply.new.targets
      targets.should be_empty
    end
  end

end
