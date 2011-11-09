require 'helper'

describe Twitter::ActionFactory do

  describe ".new" do
    it "should generate a Favorite" do
      action = Twitter::ActionFactory.new('action' => 'favorite')
      action.should be_a Twitter::Favorite
    end
    it "should generate a Follow" do
      action = Twitter::ActionFactory.new('action' => 'follow')
      action.should be_a Twitter::Follow
    end
    it "should generate a Mention" do
      action = Twitter::ActionFactory.new('action' => 'mention')
      action.should be_a Twitter::Mention
    end
    it "should generate a Reply" do
      action = Twitter::ActionFactory.new('action' => 'reply')
      action.should be_a Twitter::Reply
    end
    it "should generate a Retweet" do
      action = Twitter::ActionFactory.new('action' => 'retweet')
      action.should be_a Twitter::Retweet
    end
    it "should raise an ArgumentError when action is not specified" do
      lambda do
        Twitter::ActionFactory.new({})
      end.should raise_error(ArgumentError, "argument must have an 'action' key")
    end
  end

end
