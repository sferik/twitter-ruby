require 'helper'

describe Twitter::Retweet do

  describe "#sources" do
    it "should return a collection of users who retweeted a user" do
      sources = Twitter::Retweet.new('sources' => [{}]).sources
      sources.should be_an Array
      sources.first.should be_a Twitter::User
    end
    it "should be empty when not set" do
      sources = Twitter::Retweet.new.sources
      sources.should be_empty
    end
  end

  describe "#target_objects" do
    it "should return a collection of retweets" do
      targets = Twitter::Retweet.new('target_objects' => [{}]).target_objects
      targets.should be_an Array
      targets.first.should be_a Twitter::Status
    end
    it "should be empty when not set" do
      targets = Twitter::Retweet.new.target_objects
      targets.should be_empty
    end
  end

  describe "#targets" do
    it "should return a collection containing the retweeted user" do
      targets = Twitter::Retweet.new('targets' => [{}]).targets
      targets.should be_an Array
      targets.first.should be_a Twitter::User
    end
    it "should be empty when not set" do
      targets = Twitter::Retweet.new.targets
      targets.should be_empty
    end
  end

end
