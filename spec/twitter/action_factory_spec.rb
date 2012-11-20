require 'helper'

describe Twitter::ActionFactory do

  describe ".new" do
    it "generates a Favorite" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'favorite')
      expect(action).to be_a Twitter::Action::Favorite
    end
    it "generates a Follow" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'follow')
      expect(action).to be_a Twitter::Action::Follow
    end
    it "generates a ListMemberAdded" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'list_member_added')
      expect(action).to be_a Twitter::Action::ListMemberAdded
    end
    it "generates a Mention" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'mention')
      expect(action).to be_a Twitter::Action::Mention
    end
    it "generates a Reply" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'reply')
      expect(action).to be_a Twitter::Action::Reply
    end
    it "generates a Retweet" do
      action = Twitter::ActionFactory.fetch_or_new(:action => 'retweet')
      expect(action).to be_a Twitter::Action::Retweet
    end
    it "raises an ArgumentError when action is not specified" do
      expect{Twitter::ActionFactory.fetch_or_new}.to raise_error ArgumentError
    end
  end

end
