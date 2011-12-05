require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe ".follower_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.follower_ids("sferik")
        a_get("/1/followers/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          should have_been_made
      end
      it "should return an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids("sferik")
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should == 146197851
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.follower_ids
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "should return an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should == 146197851
      end
    end
  end

  describe ".friend_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friend_ids("sferik")
        a_get("/1/friends/ids.json").
          with(:query => {:screen_name => "sferik", :cursor => "-1"}).
          should have_been_made
      end
      it "should return an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids("sferik")
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should == 146197851
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friend_ids
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "should return an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should == 146197851
      end
    end
  end

  describe ".friendship?" do
    before do
      stub_get("/1/friendships/exists.json").
        with(:query => {:user_a => "sferik", :user_b => "pengwynn"}).
        to_return(:body => fixture("true.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1/friendships/exists.json").
        with(:query => {:user_a => "pengwynn", :user_b => "sferik"}).
        to_return(:body => fixture("false.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.friendship?("sferik", "pengwynn")
      a_get("/1/friendships/exists.json").
        with(:query => {:user_a => "sferik", :user_b => "pengwynn"}).
        should have_been_made
    end
    it "should return true if user_a follows user_b" do
      friendship = @client.friendship?("sferik", "pengwynn")
      friendship.should be_true
    end
    it "should return false if user_a does not follows user_b" do
      friendship = @client.friendship?("pengwynn", "sferik")
      friendship.should be_false
    end
  end

  describe ".friendships_incoming" do
    before do
      stub_get("/1/friendships/incoming.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.friendships_incoming
      a_get("/1/friendships/incoming.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "should return an array of numeric IDs for every user who has a pending request to follow the authenticating user" do
      friendships_incoming = @client.friendships_incoming
      friendships_incoming.should be_a Twitter::Cursor
      friendships_incoming.ids.should be_an Array
      friendships_incoming.ids.first.should == 146197851
    end
  end

  describe ".friendships_outgoing" do
    before do
      stub_get("/1/friendships/outgoing.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.friendships_outgoing
      a_get("/1/friendships/outgoing.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "should return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request" do
      friendships_outgoing = @client.friendships_outgoing
      friendships_outgoing.should be_a Twitter::Cursor
      friendships_outgoing.ids.should be_an Array
      friendships_outgoing.ids.first.should == 146197851
    end
  end

  describe ".friendship" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
          to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendship("sferik", "pengwynn")
        a_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
          should have_been_made
      end
      it "should return detailed information about the relationship between two users" do
        relationship = @client.friendship("sferik", "pengwynn")
        relationship.should be_a Twitter::Relationship
        relationship.source.screen_name.should == "sferik"
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "0", :target_screen_name => "311"}).
          to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendship("0", "311")
        a_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "0", :target_screen_name => "311"}).
          should have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1/friendships/show.json").
          with(:query => {:source_id => "7505382", :target_id => "14100886"}).
          to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendship(7505382, 14100886)
        a_get("/1/friendships/show.json").
          with(:query => {:source_id => "7505382", :target_id => "14100886"}).
          should have_been_made
      end
    end
  end

  describe ".follow" do
    context "with :follow => true passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik", :follow => "true"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.follow("sferik", :follow => true)
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik", :follow => "true"}).
          should have_been_made
      end
      it "should return the befriended user" do
        user = @client.follow("sferik", :follow => true)
        user.should be_a Twitter::User
        user.name.should == "Erik Michaels-Ober"
      end
    end
    context "with :follow => false passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.follow("sferik", :follow => false)
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "should return the befriended user" do
        user = @client.follow("sferik", :follow => false)
        user.should be_a Twitter::User
        user.name.should == "Erik Michaels-Ober"
      end
    end
    context "without :follow passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.follow("sferik")
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "should return the befriended user" do
        user = @client.follow("sferik")
        user.should be_a Twitter::User
        user.name.should == "Erik Michaels-Ober"
      end
    end
  end

  describe ".unfollow" do
    before do
      stub_delete("/1/friendships/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.unfollow("sferik")
      a_delete("/1/friendships/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the unfollowed" do
      user = @client.friendship_destroy("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

  describe ".friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("sferik", "pengwynn")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end
      it "should return up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        friendships.should be_an Array
        friendships.first.should be_a Twitter::User
        friendships.first.name.should == "Erik Michaels-Ober"
        friendships.first.connections.should == ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("0", "311")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          should have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships(7505382, 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          should have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("sferik", 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end
    end
  end

  describe ".friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("sferik", "pengwynn")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end
      it "should return up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        friendships.should be_an Array
        friendships.first.should be_a Twitter::User
        friendships.first.name.should == "Erik Michaels-Ober"
        friendships.first.connections.should == ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("0", "311")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          should have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships(7505382, 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          should have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "should request the correct resource" do
        @client.friendships("sferik", 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end
    end
  end

  describe ".friendship_update" do
    before do
      stub_post("/1/friendships/update.json").
        with(:body => {:screen_name => "sferik", :retweets => "true"}).
        to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.friendship_update("sferik", :retweets => true)
      a_post("/1/friendships/update.json").
        with(:body => {:screen_name => "sferik", :retweets => "true"}).
        should have_been_made
    end
    it "should return detailed information about the relationship between two users" do
      relationship = @client.friendship_update("sferik", :retweets => true)
      relationship.should be_a Twitter::Relationship
      relationship.source.screen_name.should == "sferik"
    end
  end

  describe ".no_retweet_ids" do
    before do
      stub_get("/1/friendships/no_retweet_ids.json").
        to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.no_retweet_ids
      a_get("/1/friendships/no_retweet_ids.json").
        should have_been_made
    end
    it "should return detailed information about the relationship between two users" do
      no_retweet_ids = @client.no_retweet_ids
      no_retweet_ids.should be_an Array
      no_retweet_ids.first.should be_an Integer
      no_retweet_ids.first.should == 47
    end
  end

  describe ".accept" do
    before do
      stub_post("/1/friendships/accept.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.accept("sferik")
      a_post("/1/friendships/accept.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the accepted user" do
      user = @client.accept("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

  describe ".deny" do
    before do
      stub_post("/1/friendships/deny.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "should request the correct resource" do
      @client.deny("sferik")
      a_post("/1/friendships/deny.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "should return the denied user" do
      user = @client.deny("sferik")
      user.should be_a Twitter::User
      user.name.should == "Erik Michaels-Ober"
    end
  end

end
