require "test_helper"

describe Twitter::REST::FriendsAndFollowers do
  before do
    @client = build_rest_client
  end

  describe "#friend_ids" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friend_ids("sferik")

        assert_requested(a_get("/1.1/friends/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids("sferik")

        assert_kind_of(Twitter::Cursor, friend_ids)
        assert_equal(20_009_713, friend_ids.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(query: {screen_name: "sferik", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friend_ids("sferik").each {}

          assert_requested(a_get("/1.1/friends/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/ids.json").with(query: {screen_name: "sferik", cursor: "1305102810874389703"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friend_ids(7_505_382)

        assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friend_ids(7_505_382).each {}

          assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friend_ids

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user the specified user is following" do
        friend_ids = @client.friend_ids

        assert_kind_of(Twitter::Cursor, friend_ids)
        assert_equal(20_009_713, friend_ids.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friend_ids.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}))
        end
      end
    end

    describe "with user_id already in options" do
      before do
        stub_get("/1.1/friends/ids.json").with(query: {user_id: "12345", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "uses the provided user_id" do
        @client.friend_ids(user_id: 12_345)

        assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "12345", cursor: "-1"}))
      end
    end

    describe "with cursor already in options" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "12345"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "uses the provided cursor" do
        @client.friend_ids(cursor: "12345")

        assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "12345"}))
      end
    end
  end

  describe "#follower_ids" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/followers/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.follower_ids("sferik")

        assert_requested(a_get("/1.1/followers/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids("sferik")

        assert_kind_of(Twitter::Cursor, follower_ids)
        assert_equal(20_009_713, follower_ids.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(query: {screen_name: "sferik", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.follower_ids("sferik").each {}

          assert_requested(a_get("/1.1/followers/ids.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/ids.json").with(query: {screen_name: "sferik", cursor: "1305102810874389703"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.follower_ids(7_505_382)

        assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.follower_ids(7_505_382).each {}

          assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.follower_ids

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        follower_ids = @client.follower_ids

        assert_kind_of(Twitter::Cursor, follower_ids)
        assert_equal(20_009_713, follower_ids.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.follower_ids.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/ids.json").with(query: {user_id: "7505382", cursor: "1305102810874389703"}))
        end
      end
    end
  end

  describe "#friendships" do
    describe "with screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(query: {screen_name: "sferik,pengwynn"}).to_return(body: fixture("friendships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships("sferik", "pengwynn")

        assert_requested(a_get("/1.1/friendships/lookup.json").with(query: {screen_name: "sferik,pengwynn"}))
      end

      it "returns up to 100 users worth of extended information" do
        friendships = @client.friendships("sferik", "pengwynn")

        assert_kind_of(Array, friendships)
        assert_kind_of(Twitter::User, friendships.first)
        assert_equal(7_505_382, friendships.first.id)
        assert_equal(["none"], friendships.first.connections)
      end
    end

    describe "with numeric screen names passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(query: {screen_name: "0,311"}).to_return(body: fixture("friendships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships("0", "311")

        assert_requested(a_get("/1.1/friendships/lookup.json").with(query: {screen_name: "0,311"}))
      end
    end

    describe "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(query: {user_id: "7505382,14100886"}).to_return(body: fixture("friendships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships(7_505_382, 14_100_886)

        assert_requested(a_get("/1.1/friendships/lookup.json").with(query: {user_id: "7505382,14100886"}))
      end
    end

    describe "with both screen names and user IDs passed" do
      before do
        stub_get("/1.1/friendships/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"}).to_return(body: fixture("friendships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships("sferik", 14_100_886)

        assert_requested(a_get("/1.1/friendships/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"}))
      end
    end
  end

  describe "#friendships_incoming" do
    before do
      stub_get("/1.1/friendships/incoming.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.friendships_incoming

      assert_requested(a_get("/1.1/friendships/incoming.json").with(query: {cursor: "-1"}))
    end

    describe "with options" do
      before do
        stub_get("/1.1/friendships/incoming.json").with(query: {cursor: "12345"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.friendships_incoming(cursor: "12345")

        assert_requested(a_get("/1.1/friendships/incoming.json").with(query: {cursor: "12345"}))
      end
    end

    it "returns an array of numeric IDs for every user who has a pending request to follow the authenticating user" do
      friendships_incoming = @client.friendships_incoming

      assert_kind_of(Twitter::Cursor, friendships_incoming)
      assert_equal(20_009_713, friendships_incoming.first)
    end

    describe "with each" do
      before do
        stub_get("/1.1/friendships/incoming.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships_incoming.each {}

        assert_requested(a_get("/1.1/friendships/incoming.json").with(query: {cursor: "1305102810874389703"}))
      end
    end
  end

  describe "#friendships_outgoing" do
    before do
      stub_get("/1.1/friendships/outgoing.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.friendships_outgoing

      assert_requested(a_get("/1.1/friendships/outgoing.json").with(query: {cursor: "-1"}))
    end

    describe "with options" do
      before do
        stub_get("/1.1/friendships/outgoing.json").with(query: {cursor: "12345"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.friendships_outgoing(cursor: "12345")

        assert_requested(a_get("/1.1/friendships/outgoing.json").with(query: {cursor: "12345"}))
      end
    end

    it "returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request" do
      friendships_outgoing = @client.friendships_outgoing

      assert_kind_of(Twitter::Cursor, friendships_outgoing)
      assert_equal(20_009_713, friendships_outgoing.first)
    end

    describe "with each" do
      before do
        stub_get("/1.1/friendships/outgoing.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendships_outgoing.each {}

        assert_requested(a_get("/1.1/friendships/outgoing.json").with(query: {cursor: "1305102810874389703"}))
      end
    end
  end

  describe "#follow" do
    before do
      stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}).to_return(body: fixture("friendships.json"), headers: json_headers)
      stub_post("/1.1/friendships/create.json").with(body: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.follow("sferik", "pengwynn")

      assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
      assert_requested(a_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}))
      assert_requested(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}))
      assert_requested(a_post("/1.1/friendships/create.json").with(body: {user_id: "7505382"}))
    end

    describe "with options" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/friends/ids.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}).to_return(body: fixture("friendships.json"), headers: json_headers)
        stub_post("/1.1/friendships/create.json").with(body: {user_id: "7505382", follow: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "passes options to the follow! request" do
        @client.follow("sferik", "pengwynn", follow: true)

        assert_requested(a_post("/1.1/friendships/create.json").with(body: {user_id: "7505382", follow: "true"}))
      end
    end

    it "passes only unfollowed IDs and options to follow! and returns its value" do
      returned_users = [Struct.new(:id).new(30)]
      looked_up_users = [Struct.new(:id).new(20), Struct.new(:id).new(30)]
      friend_ids_called = false
      users_called = false
      follow_called = false
      result = nil

      @client.stub(:friend_ids, lambda {
        friend_ids_called = true
        [10, 20]
      }) do
        @client.stub(:users, lambda { |screen_names|
          users_called = true

          assert_equal(%w[sferik pengwynn], screen_names)
          looked_up_users
        }) do
          @client.stub(:follow!, lambda { |ids, options|
            follow_called = true

            assert_equal([30], ids)
            assert_equal({follow: true}, options)
            returned_users
          }) do
            result = @client.follow("sferik", "pengwynn", {follow: true})
          end
        end
      end

      assert(friend_ids_called)
      assert(users_called)
      assert(follow_called)
      assert_operator(result, :equal?, returned_users)
    end
  end

  describe "#follow!" do
    before do
      stub_post("/1.1/friendships/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.follow!("sferik")

      assert_requested(a_post("/1.1/friendships/create.json").with(body: {screen_name: "sferik"}))
    end

    it "returns an array of befriended users" do
      users = @client.follow!("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "with a user object passed" do
    before do
      stub_post("/1.1/friendships/create.json").with(body: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resources" do
      user = Twitter::User.new(id: "7505382")
      @client.follow!(user)

      assert_requested(a_post("/1.1/friendships/create.json").with(body: {user_id: "7505382"}))
    end
  end

  describe "with a URI object passed" do
    before do
      stub_post("/1.1/friendships/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      user = URI.parse("https://twitter.com/sferik")
      @client.follow!(user)

      assert_requested(a_post("/1.1/friendships/create.json").with(body: {screen_name: "sferik"}))
    end
  end

  describe "with a forbidden error" do
    before do
      stub_post("/1.1/friendships/create.json").with(body: {screen_name: "sferik"}).to_return(status: 403, body: fixture("forbidden.json"), headers: json_headers)
    end

    it "raises an exception" do
      assert_raises(Twitter::Error::Forbidden) { @client.follow!("sferik") }
    end
  end

  describe "#unfollow" do
    before do
      stub_post("/1.1/friendships/destroy.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unfollow("sferik")

      assert_requested(a_post("/1.1/friendships/destroy.json").with(body: {screen_name: "sferik"}))
    end

    it "returns an array of unfollowed users" do
      users = @client.unfollow("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "#friendship_update" do
    before do
      stub_post("/1.1/friendships/update.json").with(body: {screen_name: "sferik", retweets: "true"}).to_return(body: fixture("following.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.friendship_update("sferik", retweets: true)

      assert_requested(a_post("/1.1/friendships/update.json").with(body: {screen_name: "sferik", retweets: "true"}))
    end

    it "returns detailed information about the relationship between two users" do
      relationship = @client.friendship_update("sferik", retweets: true)

      assert_kind_of(Twitter::Relationship, relationship)
      assert_equal(7_505_382, relationship.source.id)
    end

    describe "without options" do
      before do
        stub_post("/1.1/friendships/update.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "uses an empty hash as default options" do
        relationship = @client.friendship_update("sferik")

        assert_kind_of(Twitter::Relationship, relationship)
        assert_requested(a_post("/1.1/friendships/update.json").with(body: {screen_name: "sferik"}))
      end
    end
  end

  describe "#friendship" do
    describe "with screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendship("sferik", "pengwynn")

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}))
      end

      it "returns detailed information about the relationship between two users" do
        relationship = @client.friendship("sferik", "pengwynn")

        assert_kind_of(Twitter::Relationship, relationship)
        assert_equal(7_505_382, relationship.source.id)
      end
    end

    describe "with numeric screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "0", target_screen_name: "311"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendship("0", "311")

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_screen_name: "0", target_screen_name: "311"}))
      end
    end

    describe "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendship(7_505_382, 14_100_886)

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}))
      end
    end

    describe "with user objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user1 = Twitter::User.new(id: "7505382")
        user2 = Twitter::User.new(id: "14100886")
        @client.friendship(user1, user2)

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}))
      end
    end

    describe "with URI objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user1 = URI.parse("https://twitter.com/sferik")
        user2 = URI.parse("https://twitter.com/pengwynn")
        @client.friendship(user1, user2)

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}))
      end
    end

    describe "with options hash mutation" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn", extra: "option"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "does not mutate the original options hash" do
        options = {extra: "option"}
        options_copy = options.dup
        @client.friendship("sferik", "pengwynn", options)

        assert_equal(options_copy, options)
      end
    end
  end

  describe "#friendship?" do
    describe "with screen names passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}).to_return(body: fixture("following.json"), headers: json_headers)
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "pengwynn", target_screen_name: "sferik"}).to_return(body: fixture("not_following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendship?("sferik", "pengwynn")

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn"}))
      end

      it "returns true if user A follows user B" do
        friendship = @client.friendship?("sferik", "pengwynn")

        assert(friendship)
      end

      it "returns false if user A does not follow user B" do
        friendship = @client.friendship?("pengwynn", "sferik")

        refute(friendship)
      end
    end

    describe "with options" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn", extra: "option"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "passes options through to the request" do
        @client.friendship?("sferik", "pengwynn", extra: "option")

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_screen_name: "sferik", target_screen_name: "pengwynn", extra: "option"}))
      end
    end

    describe "with user IDs passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friendship?(7_505_382, 14_100_886)

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}))
      end
    end

    describe "with user objects passed" do
      before do
        stub_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}).to_return(body: fixture("following.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user1 = Twitter::User.new(id: "7505382")
        user2 = Twitter::User.new(id: "14100886")
        @client.friendship?(user1, user2)

        assert_requested(a_get("/1.1/friendships/show.json").with(query: {source_id: "7505382", target_id: "14100886"}))
      end
    end
  end

  describe "#followers" do
    describe "with a screen_name passed" do
      before do
        stub_get("/1.1/followers/list.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("followers_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.followers("sferik")

        assert_requested(a_get("/1.1/followers/list.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns a cursor of followers with details for every user the specified user is followed by" do
        followers = @client.followers("sferik")

        assert_kind_of(Twitter::Cursor, followers)
        assert_kind_of(Twitter::User, followers.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(query: {screen_name: "sferik", cursor: "1419103567112105362"}).to_return(body: fixture("followers_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.followers("sferik").each {}

          assert_requested(a_get("/1.1/followers/list.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/list.json").with(query: {screen_name: "sferik", cursor: "1419103567112105362"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("followers_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.followers(7_505_382)

        assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "1419103567112105362"}).to_return(body: fixture("followers_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.followers(7_505_382).each {}

          assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "1419103567112105362"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("followers_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.followers

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns a cursor of followers with details for every user the specified user is followed by" do
        followers = @client.followers

        assert_kind_of(Twitter::Cursor, followers)
        assert_kind_of(Twitter::User, followers.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "1419103567112105362"}).to_return(body: fixture("followers_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.followers.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/followers/list.json").with(query: {user_id: "7505382", cursor: "1419103567112105362"}))
        end
      end
    end
  end

  describe "#friends" do
    describe "with a screen_name passed" do
      before do
        stub_get("/1.1/friends/list.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("friends_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friends("sferik")

        assert_requested(a_get("/1.1/friends/list.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns a cursor of friends with details for every user the specified user is following" do
        friends = @client.friends("sferik")

        assert_kind_of(Twitter::Cursor, friends)
        assert_kind_of(Twitter::User, friends.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(query: {screen_name: "sferik", cursor: "1418947360875712729"}).to_return(body: fixture("friends_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friends("sferik").each {}

          assert_requested(a_get("/1.1/friends/list.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/list.json").with(query: {screen_name: "sferik", cursor: "1418947360875712729"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("friends_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friends(7_505_382)

        assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "1418947360875712729"}).to_return(body: fixture("friends_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friends(7_505_382).each {}

          assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "1418947360875712729"}))
        end
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("friends_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.friends

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns a cursor of friends with details for every user the specified user is following" do
        friends = @client.friends

        assert_kind_of(Twitter::Cursor, friends)
        assert_kind_of(Twitter::User, friends.first)
      end

      describe "with each" do
        before do
          stub_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "1418947360875712729"}).to_return(body: fixture("friends_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.friends.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/friends/list.json").with(query: {user_id: "7505382", cursor: "1418947360875712729"}))
        end
      end
    end
  end

  describe "#no_retweet_ids" do
    before do
      stub_get("/1.1/friendships/no_retweets/ids.json").to_return(body: fixture("ids.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.no_retweet_ids

      assert_requested(a_get("/1.1/friendships/no_retweets/ids.json"))
    end

    it "requests the correct resource when the alias is called" do
      @client.no_retweets_ids

      assert_requested(a_get("/1.1/friendships/no_retweets/ids.json"))
    end

    it "returns users ids of those that do not wish to be retweeted" do
      no_retweet_ids = @client.no_retweet_ids

      assert_kind_of(Array, no_retweet_ids)
      assert_kind_of(Integer, no_retweet_ids.first)
      assert_equal(47, no_retweet_ids.first)
    end

    it "coerces string ids into integers" do
      stub_get("/1.1/friendships/no_retweets/ids.json").to_return(body: "[\"47\",\"48431692\"]", headers: json_headers)

      no_retweet_ids = @client.no_retweet_ids

      assert_equal([47, 48_431_692], no_retweet_ids)
      assert(no_retweet_ids.all?(Integer))
    end

    describe "with options" do
      before do
        stub_get("/1.1/friendships/no_retweets/ids.json").with(query: {stringify_ids: "true"}).to_return(body: fixture("ids.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.no_retweet_ids(stringify_ids: true)

        assert_requested(a_get("/1.1/friendships/no_retweets/ids.json").with(query: {stringify_ids: "true"}))
      end
    end
  end
end
