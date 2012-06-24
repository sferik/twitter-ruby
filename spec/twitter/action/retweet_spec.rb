require 'helper'

describe Twitter::Action::Retweet do

  describe "#sources" do
    it "returns a collection of users who retweeted a user" do
      sources = Twitter::Action::Retweet.new(:sources => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      sources = Twitter::Action::Retweet.new.sources
      sources.should be_empty
    end
  end

  describe "#target_objects" do
    it "returns a collection of retweets" do
      targets = Twitter::Action::Retweet.new(:target_objects => [{}]).target_objects
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "is empty when not set" do
      targets = Twitter::Action::Retweet.new.target_objects
      targets.should be_empty
    end
  end

  describe "#targets" do
    it "returns a collection containing the retweeted user" do
      targets = Twitter::Action::Retweet.new(:targets => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "is empty when not set" do
      targets = Twitter::Action::Retweet.new.targets
      targets.should be_empty
    end
  end

end
