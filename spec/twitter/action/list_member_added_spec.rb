require 'helper'

describe Twitter::Action::ListMemberAdded do

  describe "#sources" do
    it "returns a collection of users who added a user to a list" do
      sources = Twitter::Action::ListMemberAdded.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::ListMemberAdded.new.sources
      sources.should be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of lists that were added to" do
      targets = Twitter::Action::ListMemberAdded.new(:target_objects => [{}]).target_objects
      targets.should be_an Array
      targets.first.should be_a Twitter::List
    end
    it "is empty when not set" do
      targets = Twitter::Action::ListMemberAdded.new.target_objects
      targets.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection of users who were added to a list" do
      targets = Twitter::Action::ListMemberAdded.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::ListMemberAdded.new.targets
      targets.should be_empty
    end
  end

end
