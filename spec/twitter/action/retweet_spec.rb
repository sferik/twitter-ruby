require 'helper'

describe Twitter::Action::Retweet do

  describe "#sources" do
    it "returns a collection of users who retweeted a user" do
      sources = Twitter::Action::Retweet.new(:sources => [{:id => 7505382}]).sources
      expect(sources).to be_an Array
      expect(sources.first).to be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Retweet.new.sources
      expect(sources).to be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of retweets" do
      targets = Twitter::Action::Retweet.new(:target_objects => [{:id => 25938088801}]).target_objects
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::Tweet
    end
    it "is empty when not set" do
      targets = Twitter::Action::Retweet.new.target_objects
      expect(targets).to be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the retweeted user" do
      targets = Twitter::Action::Retweet.new(:targets => [{:id => 7505382}]).targets
      expect(targets).to be_an Array
      expect(targets.first).to be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::Retweet.new.targets
      expect(targets).to be_empty
    end
  end

end
