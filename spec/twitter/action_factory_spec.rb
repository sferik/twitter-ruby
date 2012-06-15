require 'helper'

describe Twitter::ActionFactory do

  describe ".new" do
    it "generates a Favorite" do
      action = Twitter::ActionFactory.new('action' => 'favorite')
      action.should be_a Twitter::Favorite
    end
    it "generates a Follow" do
      action = Twitter::ActionFactory.new('action' => 'follow')
      action.should be_a Twitter::Follow
    end
    it "generates a ListMemberAdded" do
      action = Twitter::ActionFactory.new('action' => 'list_member_added')
      action.should be_a Twitter::ListMemberAdded
    end
    it "generates a Mention" do
      action = Twitter::ActionFactory.new('action' => 'mention')
      action.should be_a Twitter::Mention
    end
    it "generates a Reply" do
      action = Twitter::ActionFactory.new('action' => 'reply')
      action.should be_a Twitter::Reply
    end
    it "generates a Retweet" do
      action = Twitter::ActionFactory.new('action' => 'retweet')
      action.should be_a Twitter::Retweet
    end
    it "raises an ArgumentError when action is not specified" do
      lambda do
        Twitter::ActionFactory.new({})
      end.should raise_error(ArgumentError, "argument must have an 'action' key")
    end
  end

end
