require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#follower_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids("sferik")
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids("sferik")
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should eq 146197851
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids
        a_get("/1/followers/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids
        follower_ids.should be_a Twitter::Cursor
        follower_ids.ids.should be_an Array
        follower_ids.ids.first.should eq 146197851
      end
    end
  end

  describe "#friend_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids("sferik")
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids("sferik")
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should eq 146197851
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids
        friend_ids.should be_a Twitter::Cursor
        friend_ids.ids.should be_an Array
        friend_ids.ids.first.should eq 146197851
      end
    end
  end

  describe "#friendship?" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/exists.json").
          with(:query => {:screen_name_a => "sferik", :screen_name_b => "pengwynn"}).
          to_return(:body => fixture("true.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/friendships/exists.json").
          with(:query => {:screen_name_a => "pengwynn", :screen_name_b => "sferik"}).
          to_return(:body => fixture("false.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship?("sferik", "pengwynn")
        a_get("/1/friendships/exists.json").
          with(:query => {:screen_name_a => "sferik", :screen_name_b => "pengwynn"}).
          should have_been_made
      end
      it "returns true if user A follows user B" do
        friendship = @client.friendship?("sferik", "pengwynn")
        friendship.should be_true
      end
      it "returns false if user A does not follow user B" do
        friendship = @client.friendship?("pengwynn", "sferik")
        friendship.should be_false
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1/friendships/exists.json").
          with(:query => {:user_id_a => "7505382", :user_id_b => "14100886"}).
          to_return(:body => fixture("true.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship?(7505382, 14100886)
        a_get("/1/friendships/exists.json").
          with(:query => {:user_id_a => "7505382", :user_id_b => "14100886"}).
          should have_been_made
      end
    end
    context "with user objects passed" do
      context "with screen names" do
        before do
          stub_get("/1/friendships/exists.json").
            with(:query => {:screen_name_a => "sferik", :screen_name_b => "pengwynn"}).
            to_return(:body => fixture("true.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:screen_name => 'sferik')
          user2 = Twitter::User.new(:screen_name => 'pengwynn')
          @client.friendship?(user1, user2)
          a_get("/1/friendships/exists.json").
            with(:query => {:screen_name_a => "sferik", :screen_name_b => "pengwynn"}).
            should have_been_made
        end
      end
      context "with user IDs" do
        before do
          stub_get("/1/friendships/exists.json").
            with(:query => {:user_id_a => "7505382", :user_id_b => "14100886"}).
            to_return(:body => fixture("true.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:id => '7505382')
          user2 = Twitter::User.new(:id => '14100886')
          @client.friendship?(user1, user2)
          a_get("/1/friendships/exists.json").
            with(:query => {:user_id_a => "7505382", :user_id_b => "14100886"}).
            should have_been_made
        end
      end
    end
  end

  describe "#friendships_incoming" do
    before do
      stub_get("/1/friendships/incoming.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendships_incoming
      a_get("/1/friendships/incoming.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "returns an array of numeric IDs for every user who has a pending request to follow the authenticating user" do
      friendships_incoming = @client.friendships_incoming
      friendships_incoming.should be_a Twitter::Cursor
      friendships_incoming.ids.should be_an Array
      friendships_incoming.ids.first.should eq 146197851
    end
  end

  describe "#friendships_outgoing" do
    before do
      stub_get("/1/friendships/outgoing.json").
        with(:query => {:cursor => "-1"}).
        to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendships_outgoing
      a_get("/1/friendships/outgoing.json").
        with(:query => {:cursor => "-1"}).
        should have_been_made
    end
    it "returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request" do
      friendships_outgoing = @client.friendships_outgoing
      friendships_outgoing.should be_a Twitter::Cursor
      friendships_outgoing.ids.should be_an Array
      friendships_outgoing.ids.first.should eq 146197851
    end
  end

  describe "#friendship" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
          to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship("sferik", "pengwynn")
        a_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
          should have_been_made
      end
      it "returns detailed information about the relationship between two users" do
        relationship = @client.friendship("sferik", "pengwynn")
        relationship.should be_a Twitter::Relationship
        relationship.source.screen_name.should eq "sferik"
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/show.json").
          with(:query => {:source_screen_name => "0", :target_screen_name => "311"}).
          to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
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
      it "requests the correct resource" do
        @client.friendship(7505382, 14100886)
        a_get("/1/friendships/show.json").
          with(:query => {:source_id => "7505382", :target_id => "14100886"}).
          should have_been_made
      end
    end
    context "with user objects passed" do
      context "with screen names" do
        before do
          stub_get("/1/friendships/show.json").
            with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
            to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:screen_name => 'sferik')
          user2 = Twitter::User.new(:screen_name => 'pengwynn')
          @client.friendship(user1, user2)
          a_get("/1/friendships/show.json").
            with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).
            should have_been_made
        end
      end
      context "with user IDs" do
        before do
          stub_get("/1/friendships/show.json").
            with(:query => {:source_id => "7505382", :target_id => "14100886"}).
            to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:id => '7505382')
          user2 = Twitter::User.new(:id => '14100886')
          @client.friendship(user1, user2)
          a_get("/1/friendships/show.json").
            with(:query => {:source_id => "7505382", :target_id => "14100886"}).
            should have_been_made
        end
      end
    end
  end

  describe "#follow" do
    context "with :follow => true passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382", :follow => "true"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => true)
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
        a_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382", :follow => "true"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn", :follow => true)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "with :follow => false passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => false)
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
        a_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn", :follow => false)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "without :follow passed" do
      before do
        stub_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("id_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn")
        a_get("/1/friends/ids.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
        a_post("/1/friendships/create.json").
          with(:body => {:user_id => "7505382"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn")
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
  end

  describe "#follow!" do
    context "with :follow => true passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik", :follow => "true"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik", :follow => true)
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik", :follow => "true"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik", :follow => true)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "with :follow => false passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik", :follow => false)
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik", :follow => false)
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "without :follow passed" do
      before do
        stub_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik")
        a_post("/1/friendships/create.json").
          with(:body => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik")
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
  end

  describe "#unfollow" do
    before do
      stub_delete("/1/friendships/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unfollow("sferik")
      a_delete("/1/friendships/destroy.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of unfollowed users" do
      users = @client.friendship_destroy("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", "pengwynn")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        friendships.should be_an Array
        friendships.first.should be_a Twitter::User
        friendships.first.name.should eq "Erik Michaels-Ober"
        friendships.first.connections.should eq ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
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
      it "requests the correct resource" do
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
      it "requests the correct resource" do
        @client.friendships("sferik", 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end
    end
  end

  describe "#friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", "pengwynn")
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        friendships.should be_an Array
        friendships.first.should be_a Twitter::User
        friendships.first.name.should eq "Erik Michaels-Ober"
        friendships.first.connections.should eq ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
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
      it "requests the correct resource" do
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
      it "requests the correct resource" do
        @client.friendships("sferik", 14100886)
        a_get("/1/friendships/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end
    end
  end

  describe "#friendship_update" do
    before do
      stub_post("/1/friendships/update.json").
        with(:body => {:screen_name => "sferik", :retweets => "true"}).
        to_return(:body => fixture("relationship.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendship_update("sferik", :retweets => true)
      a_post("/1/friendships/update.json").
        with(:body => {:screen_name => "sferik", :retweets => "true"}).
        should have_been_made
    end
    it "returns detailed information about the relationship between two users" do
      relationship = @client.friendship_update("sferik", :retweets => true)
      relationship.should be_a Twitter::Relationship
      relationship.source.screen_name.should eq "sferik"
    end
  end

  describe "#no_retweet_ids" do
    before do
      stub_get("/1/friendships/no_retweet_ids.json").
        to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.no_retweet_ids
      a_get("/1/friendships/no_retweet_ids.json").
        should have_been_made
    end
    it "returns detailed information about the relationship between two users" do
      no_retweet_ids = @client.no_retweet_ids
      no_retweet_ids.should be_an Array
      no_retweet_ids.first.should be_an Integer
      no_retweet_ids.first.should eq 47
    end
  end

  describe "#accept" do
    before do
      stub_post("/1/friendships/accept.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.accept("sferik")
      a_post("/1/friendships/accept.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of accepted users" do
      users = @client.accept("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#deny" do
    before do
      stub_post("/1/friendships/deny.json").
        with(:body => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.deny("sferik")
      a_post("/1/friendships/deny.json").
        with(:body => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns an array of denied users" do
      users = @client.deny("sferik")
      users.should be_an Array
      users.first.should be_a Twitter::User
      users.first.name.should eq "Erik Michaels-Ober"
    end
  end

end
