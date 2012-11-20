require 'helper'

describe Twitter::API::FriendsAndFollowers do

  before do
    @client = Twitter::Client.new
  end

  describe "#friend_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids("sferik")
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids("sferik")
        expect(friend_ids).to be_a Twitter::Cursor
        expect(friend_ids.ids).to be_an Array
        expect(friend_ids.ids.first).to eq 14100886
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids
        expect(friend_ids).to be_a Twitter::Cursor
        expect(friend_ids.ids).to be_an Array
        expect(friend_ids.ids.first).to eq 14100886
      end
    end
  end

  describe "#follower_ids" do
    context "with a screen_name passed" do
      before do
        stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids("sferik")
        expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids("sferik")
        expect(follower_ids).to be_a Twitter::Cursor
        expect(follower_ids.ids).to be_an Array
        expect(follower_ids.ids.first).to eq 14100886
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids
        expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids
        expect(follower_ids).to be_a Twitter::Cursor
        expect(follower_ids.ids).to be_an Array
        expect(follower_ids.ids.first).to eq 14100886
      end
    end
  end

  describe "#friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", "pengwynn")
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik,pengwynn"})).to have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        expect(friendships).to be_an Array
        expect(friendships.first).to be_a Twitter::User
        expect(friendships.first.id).to eq 7505382
        expect(friendships.first.connections).to eq ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "0,311"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("0", "311")
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "0,311"})).to have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:user_id => "7505382,14100886"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships(7505382, 14100886)
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:user_id => "7505382,14100886"})).to have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik", :user_id => "14100886"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", 14100886)
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik", :user_id => "14100886"})).to have_been_made
      end
    end
  end

  describe "#friendships" do
    context "with screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", "pengwynn")
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik,pengwynn"})).to have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")
        expect(friendships).to be_an Array
        expect(friendships.first).to be_a Twitter::User
        expect(friendships.first.id).to eq 7505382
        expect(friendships.first.connections).to eq ["none"]
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "0,311"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("0", "311")
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "0,311"})).to have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:user_id => "7505382,14100886"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships(7505382, 14100886)
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:user_id => "7505382,14100886"})).to have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik", :user_id => "14100886"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships("sferik", 14100886)
        expect(a_get("/1.1/friendships/lookup.json").with(:query => {:screen_name => "sferik", :user_id => "14100886"})).to have_been_made
      end
    end
  end

  describe "#friendships_incoming" do
    before do
      stub_get("/1.1/friendships/incoming.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendships_incoming
      expect(a_get("/1.1/friendships/incoming.json").with(:query => {:cursor => "-1"})).to have_been_made
    end
    it "returns an array of numeric IDs for every user who has a pending request to follow the authenticating user" do
      friendships_incoming = @client.friendships_incoming
      expect(friendships_incoming).to be_a Twitter::Cursor
      expect(friendships_incoming.ids).to be_an Array
      expect(friendships_incoming.ids.first).to eq 14100886
    end
  end

  describe "#friendships_outgoing" do
    before do
      stub_get("/1.1/friendships/outgoing.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendships_outgoing
      expect(a_get("/1.1/friendships/outgoing.json").with(:query => {:cursor => "-1"})).to have_been_made
    end
    it "returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request" do
      friendships_outgoing = @client.friendships_outgoing
      expect(friendships_outgoing).to be_a Twitter::Cursor
      expect(friendships_outgoing.ids).to be_an Array
      expect(friendships_outgoing.ids.first).to eq 14100886
    end
  end

  describe "#follow" do
    context "with :follow => true passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382", :follow => "true"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => true)
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382", :follow => "true"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn", :follow => true)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
    context "with :follow => false passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => false)
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn", :follow => false)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
    context "without :follow passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn")
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn")
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
  end

  describe "#follow!" do
    context "with :follow => true passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik", :follow => "true"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik", :follow => true)
        expect(a_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik", :follow => "true"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik", :follow => true)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
    context "with :follow => false passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik", :follow => false)
        expect(a_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik", :follow => false)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
    context "without :follow passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("sferik")
        expect(a_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow!("sferik")
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
  end

  describe "#unfollow" do
    before do
      stub_post("/1.1/friendships/destroy.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.unfollow("sferik")
      expect(a_post("/1.1/friendships/destroy.json").with(:body => {:screen_name => "sferik"})).to have_been_made
    end
    it "returns an array of unfollowed users" do
      users = @client.friendship_destroy("sferik")
      expect(users).to be_an Array
      expect(users.first).to be_a Twitter::User
      expect(users.first.id).to eq 7505382
    end
  end

  describe "#friendship_update" do
    before do
      stub_post("/1.1/friendships/update.json").with(:body => {:screen_name => "sferik", :retweets => "true"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.friendship_update("sferik", :retweets => true)
      expect(a_post("/1.1/friendships/update.json").with(:body => {:screen_name => "sferik", :retweets => "true"})).to have_been_made
    end
    it "returns detailed information about the relationship between two users" do
      relationship = @client.friendship_update("sferik", :retweets => true)
      expect(relationship).to be_a Twitter::Relationship
      expect(relationship.source.id).to eq 7505382
    end
  end

  describe "#friendship" do
    context "with screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship("sferik", "pengwynn")
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"})).to have_been_made
      end
      it "returns detailed information about the relationship between two users" do
        relationship = @client.friendship("sferik", "pengwynn")
        expect(relationship).to be_a Twitter::Relationship
        expect(relationship.source.id).to eq 7505382
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "0", :target_screen_name => "311"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship("0", "311")
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "0", :target_screen_name => "311"})).to have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship(7505382, 14100886)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
    context "with user objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user1 = Twitter::User.new(:id => '7505382')
        user2 = Twitter::User.new(:id => '14100886')
        @client.friendship(user1, user2)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
  end

  describe "#friendship?" do
    context "with screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "pengwynn", :target_screen_name => "sferik"}).to_return(:body => fixture("not_following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship?("sferik", "pengwynn")
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"})).to have_been_made
      end
      it "returns true if user A follows user B" do
        friendship = @client.friendship?("sferik", "pengwynn")
        expect(friendship).to be_true
      end
      it "returns false if user A does not follow user B" do
        friendship = @client.friendship?("pengwynn", "sferik")
        expect(friendship).to be_false
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship?(7505382, 14100886)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
    context "with user objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user1 = Twitter::User.new(:id => '7505382')
        user2 = Twitter::User.new(:id => '14100886')
        @client.friendship?(user1, user2)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
  end

end
