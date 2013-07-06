require 'helper'

describe Twitter::Action::ListMemberAdded do

  describe "#sources" do
    it "returns a collection of users who added a user to a list" do
      sources = Twitter::Action::ListMemberAdded.new(:sources => [{:id => 7505382}]).sources
      expect(sources).to be_an Array
      expect(sources.first).to be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::ListMemberAdded.new.sources
      expect(sources).to be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of lists that were added to" do
      targets = Twitter::Action::ListMemberAdded.new(:target_objects => [{:id => 8863586}]).target_objects
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::List
    end
    it "is empty when not set" do
      targets = Twitter::Action::ListMemberAdded.new.target_objects
      expect(targets).to be_empty
    end
  end

  describe "#targets" do
    it "returns a collection of users who were added to a list" do
      targets = Twitter::Action::ListMemberAdded.new(:targets => [{:id => 7505382}]).targets
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::ListMemberAdded.new.targets
      expect(targets).to be_empty
    end
  end

end
