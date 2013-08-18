require 'helper'

describe Twitter::REST::API::FriendsAndFollowers do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#friend_ids" do
    context "with a screen name passed" do
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
        expect(friend_ids.first).to eq(20009713)
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friend_ids("sferik").each{}
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids(7505382)
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :user_id => "7505382"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friend_ids(7505382).each{}
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :user_id => "7505382"})).to have_been_made
        end
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friend_ids
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids
        expect(friend_ids).to be_a Twitter::Cursor
        expect(friend_ids.first).to eq(20009713)
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friend_ids.each{}
          expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
  end

  describe "#follower_ids" do
    context "with a screen name passed" do
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
        expect(follower_ids.first).to eq(20009713)
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.follower_ids("sferik").each{}
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids(7505382)
        expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :user_id => "7505382"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.follower_ids(7505382).each{}
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :user_id => "7505382"})).to have_been_made
        end
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follower_ids
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids
        expect(follower_ids).to be_a Twitter::Cursor
        expect(follower_ids.first).to eq(20009713)
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.follower_ids.each{}
          expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/followers/ids.json").with(:query => {:cursor => "1305102810874389703", :screen_name => "sferik"})).to have_been_made
        end
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
        expect(friendships.first.id).to eq(7505382)
        expect(friendships.first.connections).to eq(["none"])
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
        expect(friendships.first.id).to eq(7505382)
        expect(friendships.first.connections).to eq(["none"])
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
      expect(friendships_incoming.first).to eq(20009713)
    end
    context "with each" do
      before do
        stub_get("/1.1/friendships/incoming.json").with(:query => {:cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships_incoming.each{}
        expect(a_get("/1.1/friendships/incoming.json").with(:query => {:cursor => "1305102810874389703"})).to have_been_made
      end
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
      expect(friendships_outgoing.first).to eq(20009713)
    end
    context "with each" do
      before do
        stub_get("/1.1/friendships/outgoing.json").with(:query => {:cursor => "1305102810874389703"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendships_outgoing.each{}
        expect(a_get("/1.1/friendships/outgoing.json").with(:query => {:cursor => "1305102810874389703"})).to have_been_made
      end
    end
  end

  describe "#follow" do
    context "with :follow => true passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382", :follow => "true"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => true)
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382", :follow => "true"})).to have_been_made
      end
      it "returns an array of befriended users" do
        users = @client.follow("sferik", "pengwynn", :follow => true)
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq(7505382)
      end
    end
    context "with :follow => false passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn", :follow => false)
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"})).to have_been_made
      end
    end
    context "without :follow passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("ids_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("friendships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow("sferik", "pengwynn")
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/friends/ids.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"})).to have_been_made
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
        expect(users.first.id).to eq(7505382)
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
        expect(users.first.id).to eq(7505382)
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
        expect(users.first.id).to eq(7505382)
      end
    end
    context "with a user object passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resources" do
        user = Twitter::User.new(:id => "7505382")
        @client.follow!(user)
        expect(a_post("/1.1/friendships/create.json").with(:body => {:user_id => "7505382"})).to have_been_made
      end
    end
    context "with a URI object passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user = URI.parse("https://twitter.com/sferik")
        @client.follow!(user)
        expect(a_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"})).to have_been_made
      end
    end
    context "with a URI string passed" do
      before do
        stub_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.follow!("https://twitter.com/sferik")
        expect(a_post("/1.1/friendships/create.json").with(:body => {:screen_name => "sferik"})).to have_been_made
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
      expect(users.first.id).to eq(7505382)
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
      expect(relationship.source.id).to eq(7505382)
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
        expect(relationship.source.id).to eq(7505382)
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
        user1 = Twitter::User.new(:id => "7505382")
        user2 = Twitter::User.new(:id => "14100886")
        @client.friendship(user1, user2)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
    context "with URI objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user1 = URI.parse("https://twitter.com/sferik")
        user2 = URI.parse("https://twitter.com/pengwynn")
        @client.friendship(user1, user2)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"})).to have_been_made
      end
    end
    context "with URI strings passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"}).to_return(:body => fixture("following.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friendship("https://twitter.com/sferik", "https://twitter.com/pengwynn")
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_screen_name => "sferik", :target_screen_name => "pengwynn"})).to have_been_made
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
        user1 = Twitter::User.new(:id => "7505382")
        user2 = Twitter::User.new(:id => "14100886")
        @client.friendship?(user1, user2)
        expect(a_get("/1.1/friendships/show.json").with(:query => {:source_id => "7505382", :target_id => "14100886"})).to have_been_made
      end
    end
  end

  describe "#followers" do
    context "with a screen_name passed" do
      before do
        stub_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("followers_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.followers("sferik")
        expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns a cursor of followers with details for every user the specified user is followed by" do
        followers = @client.followers("sferik")
        expect(followers).to be_a Twitter::Cursor
        expect(followers.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :screen_name => "sferik"}).to_return(:body => fixture("followers_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.followers("sferik").each{}
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"}).to_return(:body => fixture("followers_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.followers(7505382)
        expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :user_id => "7505382"}).to_return(:body => fixture("followers_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.followers(7505382).each{}
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :user_id => "7505382"})).to have_been_made
        end
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("followers_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.followers
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns a cursor of followers with details for every user the specified user is followed by" do
        followers = @client.followers
        expect(followers).to be_a Twitter::Cursor
        expect(followers.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :screen_name => "sferik"}).to_return(:body => fixture("followers_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.followers.each{}
          expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/followers/list.json").with(:query => {:cursor => "1419103567112105362", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
  end

  describe "#friends" do
    context "with a screen_name passed" do
      before do
        stub_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("friends_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friends("sferik")
        expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns a cursor of friends with details for every user the specified user is following" do
        friends = @client.friends("sferik")
        expect(friends).to be_a Twitter::Cursor
        expect(friends.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :screen_name => "sferik"}).to_return(:body => fixture("friends_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friends("sferik").each{}
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"}).to_return(:body => fixture("friends_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friends(7505382)
        expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :user_id => "7505382"}).to_return(:body => fixture("friends_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friends(7505382).each{}
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :user_id => "7505382"})).to have_been_made
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :user_id => "7505382"})).to have_been_made
        end
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("friends_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.friends
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns a cursor of friends with details for every user the specified user is following" do
        friends = @client.friends
        expect(friends).to be_a Twitter::Cursor
        expect(friends.first).to be_a Twitter::User
      end
      context "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :screen_name => "sferik"}).to_return(:body => fixture("friends_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.friends.each{}
          expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
          expect(a_get("/1.1/friends/list.json").with(:query => {:cursor => "1418947360875712729", :screen_name => "sferik"})).to have_been_made
        end
      end
    end
  end

  describe "#no_retweet_ids" do
    before do
      stub_get("/1.1/friendships/no_retweets/ids.json").to_return(:body => fixture("ids.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.no_retweet_ids
      expect(a_get("/1.1/friendships/no_retweets/ids.json")).to have_been_made
    end
    it "requests the correct resource when the alias is called" do
      @client.no_retweets_ids
      expect(a_get("/1.1/friendships/no_retweets/ids.json")).to have_been_made
    end
    it "returns users ids of those that do not wish to be retweeted" do
      no_retweet_ids = @client.no_retweet_ids
      expect(no_retweet_ids).to be_an Array
      expect(no_retweet_ids.first).to be_an Integer
      expect(no_retweet_ids.first).to eq(47)
    end
  end
end
