require "test_helper"

describe Twitter::REST::Users do
  before do
    @client = build_rest_client
  end

  describe "#suggestions" do
    describe "with a category slug passed" do
      before do
        stub_get("/1.1/users/suggestions/art-design.json").to_return(body: fixture("category.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.suggestions("art-design")

        assert_requested(a_get("/1.1/users/suggestions/art-design.json"))
      end

      it "returns the users in a given category of the Twitter suggested user list" do
        suggestion = @client.suggestions("art-design")

        assert_kind_of(Twitter::Suggestion, suggestion)
        assert_equal("Art & Design", suggestion.name)
        assert_kind_of(Array, suggestion.users)
        assert_kind_of(Twitter::User, suggestion.users.first)
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/users/suggestions.json").to_return(body: fixture("suggestions.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.suggestions

        assert_requested(a_get("/1.1/users/suggestions.json"))
      end

      it "returns the list of suggested user categories" do
        suggestions = @client.suggestions

        assert_kind_of(Array, suggestions)
        assert_kind_of(Twitter::Suggestion, suggestions.first)
        assert_equal("Art & Design", suggestions.first.name)
      end
    end
  end

  describe "#suggest_users" do
    before do
      stub_get("/1.1/users/suggestions/art-design/members.json").to_return(body: fixture("members.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.suggest_users("art-design")

      assert_requested(a_get("/1.1/users/suggestions/art-design/members.json"))
    end

    it "returns users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user" do
      suggest_users = @client.suggest_users("art-design")

      assert_kind_of(Array, suggest_users)
      assert_kind_of(Twitter::User, suggest_users.first)
      assert_equal(13, suggest_users.first.id)
    end
  end

  describe "#blocked" do
    before do
      stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.blocked

      assert_requested(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}))
    end

    it "returns an array of user objects that the authenticating user is blocking" do
      blocked = @client.blocked

      assert_kind_of(Twitter::Cursor, blocked)
      assert_kind_of(Twitter::User, blocked.first)
      assert_equal(7_505_382, blocked.first.id)
    end

    describe "with options passed" do
      before do
        stub_get("/1.1/blocks/list.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.blocked(skip_status: true)

        assert_requested(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1", skip_status: "true"}))
      end
    end

    describe "with each" do
      before do
        stub_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.blocked.each {}

        assert_requested(a_get("/1.1/blocks/list.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/blocks/list.json").with(query: {cursor: "1322801608223717003"}))
      end
    end
  end

  describe "#blocked_ids" do
    before do
      stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.blocked_ids

      assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}))
    end

    it "returns an array of numeric user IDs the authenticating user is blocking" do
      blocked_ids = @client.blocked_ids

      assert_kind_of(Twitter::Cursor, blocked_ids)
      assert_equal(20_009_713, blocked_ids.first)
    end

    describe "with a user passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", user_id: "7505382"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "passes user_id to the request" do
        @client.blocked_ids(7_505_382)

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", user_id: "7505382"}))
      end
    end

    describe "with each" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.blocked_ids.each {}

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}))
      end
    end
  end

  describe "#block?" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: json_headers)
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.block?("sferik")

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}))
        assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}))
      end

      it "returns true if block exists" do
        block = @client.block?("pengwynn")

        assert(block)
      end

      it "returns false if block does not exist" do
        block = @client.block?("sferik")

        refute(block)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resources" do
        @client.block?(7_505_382)

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}))
      end

      it "returns true when the integer user ID is in the block list" do
        block = @client.block?(20_009_713)

        assert(block)
      end

      it "returns false when the integer user ID is not in the block list" do
        block = @client.block?(999_999_999)

        refute(block)
      end
    end

    describe "with a user object passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resources" do
        user = Twitter::User.new(id: "7505382")
        @client.block?(user)

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}))
      end

      it "returns true when user object id is in the block list" do
        user = Twitter::User.new(id: 20_009_713)
        block = @client.block?(user)

        assert(block)
      end

      it "returns false when user object id is not in the block list" do
        user = Twitter::User.new(id: 999_999_999)
        block = @client.block?(user)

        refute(block)
      end
    end

    describe "with a URI passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: json_headers)
      end

      it "returns true when URI user is in the block list" do
        uri = URI.parse("https://twitter.com/pengwynn")
        block = @client.block?(uri)

        assert(block)
      end
    end

    describe "with an Addressable::URI passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
        stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("pengwynn.json"), headers: json_headers)
      end

      it "returns true when Addressable::URI user is in the block list" do
        uri = Addressable::URI.parse("https://twitter.com/pengwynn")
        block = @client.block?(uri)

        assert(block)
      end
    end

    describe "with nil passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "returns false" do
        block = @client.block?(nil)

        refute(block)
      end
    end

    describe "with options passed" do
      before do
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
        stub_get("/1.1/blocks/ids.json").with(query: {cursor: "1305102810874389703", skip_status: "true"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "passes options to blocked_ids" do
        @client.block?(14_100_886, skip_status: true)

        assert_requested(a_get("/1.1/blocks/ids.json").with(query: {cursor: "-1", skip_status: "true"}))
      end
    end

    it "coerces blocked IDs to integers and uses empty options by default" do
      @client.stub(:blocked_ids, lambda { |options = {}|
        assert_empty(options)
        ["20009713"]
      }) do
        assert(@client.block?(20_009_713))
      end
    end
  end

  describe "#block" do
    before do
      stub_post("/1.1/blocks/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.block("sferik")

      assert_requested(a_post("/1.1/blocks/create.json"))
    end

    it "returns an array of blocked users" do
      users = @client.block("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "#unblock" do
    before do
      stub_post("/1.1/blocks/destroy.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unblock("sferik")

      assert_requested(a_post("/1.1/blocks/destroy.json").with(body: {screen_name: "sferik"}))
    end

    it "returns an array of un-blocked users" do
      users = @client.unblock("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "#users" do
    describe "with screen names passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}).to_return(body: fixture("users.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.users("sferik", "pengwynn")

        assert_requested(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}))
      end

      it "returns up to 100 users worth of extended information" do
        users = @client.users("sferik", "pengwynn")

        assert_kind_of(Array, users)
        assert_kind_of(Twitter::User, users.first)
        assert_equal(7_505_382, users.first.id)
      end

      describe "with URI objects passed" do
        it "requests the correct resource" do
          sferik = URI.parse("https://twitter.com/sferik")
          pengwynn = URI.parse("https://twitter.com/pengwynn")
          @client.users(sferik, pengwynn)

          assert_requested(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik,pengwynn"}))
        end
      end
    end

    describe "with numeric screen names passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "0,311"}).to_return(body: fixture("users.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.users("0", "311")

        assert_requested(a_get("/1.1/users/lookup.json").with(query: {screen_name: "0,311"}))
      end
    end

    describe "with user IDs passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}).to_return(body: fixture("users.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.users(7_505_382, 14_100_886)

        assert_requested(a_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}))
      end
    end

    describe "with both screen names and user IDs passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"}).to_return(body: fixture("users.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.users("sferik", 14_100_886)

        assert_requested(a_get("/1.1/users/lookup.json").with(query: {screen_name: "sferik", user_id: "14100886"}))
      end
    end

    describe "with user objects passed" do
      before do
        stub_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}).to_return(body: fixture("users.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user1 = Twitter::User.new(id: 7_505_382)
        user2 = Twitter::User.new(id: 14_100_886)
        @client.users(user1, user2)

        assert_requested(a_get("/1.1/users/lookup.json").with(query: {user_id: "7505382,14100886"}))
      end
    end
  end

  describe "#user" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user("sferik")

        assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}))
      end

      it "returns extended information of a given user" do
        user = @client.user("sferik")

        assert_kind_of(Twitter::User, user)
        assert_equal(7_505_382, user.id)
      end
    end

    describe 'with a screen name including "@" passed' do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "@sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user("@sferik")

        assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "@sferik"}))
      end
    end

    describe "with a numeric screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "0"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user("0")

        assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "0"}))
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user(7_505_382)

        assert_requested(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "with a user object passed" do
      before do
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user = Twitter::User.new(id: 7_505_382)
        @client.user(user)

        assert_requested(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "when user_id is memoized and no user argument is passed" do
      before do
        @client.instance_variable_set(:@user_id, 7_505_382)
        stub_get("/1.1/users/show.json").with(query: {user_id: "7505382"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "uses users/show with the cached user_id instead of verify_credentials" do
        @client.user

        assert_requested(a_get("/1.1/users/show.json").with(query: {user_id: "7505382"}))
        assert_not_requested(a_get("/1.1/account/verify_credentials.json"))
      end
    end
  end

  describe "without a screen name or user ID passed" do
    describe "without options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user

        assert_requested(a_get("/1.1/account/verify_credentials.json"))
      end
    end

    describe "with options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.user(skip_status: true)

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
      end
    end
  end

  describe "#user?" do
    before do
      stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      stub_get("/1.1/users/show.json").with(query: {screen_name: "pengwynn"}).to_return(body: fixture("not_found.json"), status: 404, headers: json_headers)
    end

    it "requests the correct resource" do
      @client.user?("sferik")

      assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik"}))
    end

    it "returns true if user exists" do
      user = @client.user?("sferik")

      assert_true(user)
    end

    it "returns false if user does not exist" do
      user = @client.user?("pengwynn")

      assert_false(user)
    end

    describe "with options" do
      before do
        stub_get("/1.1/users/show.json").with(query: {screen_name: "sferik", skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "does not modify the original options hash" do
        options = {skip_status: true}
        @client.user?("sferik", options)

        assert_equal({skip_status: true}, options)
        assert_requested(a_get("/1.1/users/show.json").with(query: {screen_name: "sferik", skip_status: "true"}))
      end
    end
  end

  describe "#user_search" do
    before do
      stub_get("/1.1/users/search.json").with(query: {q: "Erik Berlin"}).to_return(body: fixture("user_search.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.user_search("Erik Berlin")

      assert_requested(a_get("/1.1/users/search.json").with(query: {q: "Erik Berlin"}))
    end

    it "returns an array of user search results" do
      user_search = @client.user_search("Erik Berlin")

      assert_kind_of(Array, user_search)
      assert_kind_of(Twitter::User, user_search.first)
      assert_equal(7_505_382, user_search.first.id)
    end

    describe "with options" do
      before do
        stub_get("/1.1/users/search.json").with(query: {q: "Erik Berlin", page: "2"}).to_return(body: fixture("user_search.json"), headers: json_headers)
      end

      it "does not modify the original options hash" do
        options = {page: 2}
        @client.user_search("Erik Berlin", options)

        assert_equal({page: 2}, options)
        refute(options.key?(:q))
        assert_requested(a_get("/1.1/users/search.json").with(query: {q: "Erik Berlin", page: "2"}))
      end
    end
  end

  describe "#contributees" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("contributees.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributees("sferik")

        assert_requested(a_get("/1.1/users/contributees.json").with(query: {screen_name: "sferik"}))
      end

      it "returns contributees" do
        contributees = @client.contributees("sferik")

        assert_kind_of(Array, contributees)
        assert_kind_of(Twitter::User, contributees.first)
        assert_equal("Twitter API", contributees.first.name)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributees(7_505_382)

        assert_requested(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributees

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}))
      end

      it "returns contributees" do
        contributees = @client.contributees

        assert_kind_of(Array, contributees)
        assert_kind_of(Twitter::User, contributees.first)
        assert_equal("Twitter API", contributees.first.name)
      end
    end

    describe "with user_id in options" do
      before do
        stub_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}).to_return(body: fixture("contributees.json"), headers: json_headers)
      end

      it "does not call verify_credentials when user_id is already in options" do
        @client.contributees(user_id: 7_505_382)

        assert_requested(a_get("/1.1/users/contributees.json").with(query: {user_id: "7505382"}))
      end
    end
  end

  describe "#contributors" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/users/contributors.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("members.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributors("sferik")

        assert_requested(a_get("/1.1/users/contributors.json").with(query: {screen_name: "sferik"}))
      end

      it "returns contributors" do
        contributors = @client.contributors("sferik")

        assert_kind_of(Array, contributors)
        assert_kind_of(Twitter::User, contributors.first)
        assert_equal(13, contributors.first.id)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}).to_return(body: fixture("members.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributors(7_505_382)

        assert_requested(a_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}).to_return(body: fixture("members.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.contributors

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/users/contributors.json").with(query: {user_id: "7505382"}))
      end

      it "returns contributors" do
        contributors = @client.contributors

        assert_kind_of(Array, contributors)
        assert_kind_of(Twitter::User, contributors.first)
        assert_equal(13, contributors.first.id)
      end
    end
  end

  describe "#remove_profile_banner" do
    before do
      stub_post("/1.1/account/remove_profile_banner.json").to_return(body: "{}", headers: json_headers)
    end

    it "requests the correct resource" do
      @client.remove_profile_banner

      assert_requested(a_post("/1.1/account/remove_profile_banner.json"))
    end

    it "returns true" do
      response = @client.remove_profile_banner

      assert_true(response)
    end

    describe "with options" do
      before do
        stub_post("/1.1/account/remove_profile_banner.json").with(body: {include_entities: "true"}).to_return(body: "{}", headers: json_headers)
      end

      it "passes options in the request" do
        @client.remove_profile_banner(include_entities: true)

        assert_requested(a_post("/1.1/account/remove_profile_banner.json").with(body: {include_entities: "true"}))
      end
    end
  end

  describe "#update_profile_banner" do
    before do
      stub_post("/1.1/account/update_profile_banner.json").to_return(body: "{}", headers: json_headers)
    end

    it "requests the correct resource" do
      @client.update_profile_banner(fixture_file("me.jpeg"))

      assert_requested(a_post("/1.1/account/update_profile_banner.json"))
    end

    it "returns true" do
      response = @client.update_profile_banner(fixture_file("me.jpeg"))

      assert_true(response)
    end

    describe "with options" do
      it "passes options in the request" do
        @client.update_profile_banner(fixture_file("me.jpeg"), width: 800, height: 400)

        assert_requested(a_post("/1.1/account/update_profile_banner.json").with do |req|
          req.body.include?("width") && req.body.include?("height")
        end)
      end
    end

    it "returns true and merges the banner into options using the :banner key" do
      banner = fixture_file("me.jpeg")

      @client.stub(:perform_post, lambda { |path, options|
        assert_equal("/1.1/account/update_profile_banner.json", path)
        assert_equal(800, options[:width])
        assert_equal(banner, options[:banner])
        {}
      }) do
        assert_true(@client.update_profile_banner(banner, width: 800))
      end
    end
  end

  describe "#profile_banner" do
    describe "with a screen_name passed" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("profile_banner.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.profile_banner("sferik")

        assert_requested(a_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}))
      end

      it "returns a profile banner" do
        banner = @client.profile_banner("sferik")

        assert_kind_of(Twitter::ProfileBanner, banner)
        assert_kind_of(Hash, banner.sizes)
        assert_equal(160, banner.sizes[:mobile].height)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.profile_banner(7_505_382)

        assert_requested(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.profile_banner

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}))
      end

      it "returns an array of numeric IDs for every user following the specified user" do
        banner = @client.profile_banner

        assert_kind_of(Twitter::ProfileBanner, banner)
        assert_kind_of(Hash, banner.sizes)
        assert_equal(160, banner.sizes[:mobile].height)
      end
    end

    describe "with user_id in options" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}).to_return(body: fixture("profile_banner.json"), headers: json_headers)
      end

      it "does not call verify_credentials when user_id is already in options" do
        @client.profile_banner(user_id: 7_505_382)

        assert_requested(a_get("/1.1/users/profile_banner.json").with(query: {user_id: "7505382"}))
      end
    end

    describe "with screen_name in options" do
      before do
        stub_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}).to_return(body: fixture("profile_banner.json"), headers: json_headers)
      end

      it "does not call verify_credentials when screen_name is already in options" do
        @client.profile_banner(screen_name: "sferik")

        assert_requested(a_get("/1.1/users/profile_banner.json").with(query: {screen_name: "sferik"}))
      end
    end
  end

  describe "#mute" do
    before do
      stub_post("/1.1/mutes/users/create.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.mute("sferik")

      assert_requested(a_post("/1.1/mutes/users/create.json"))
    end

    it "returns an array of muteed users" do
      users = @client.mute("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "#unmute" do
    before do
      stub_post("/1.1/mutes/users/destroy.json").with(body: {screen_name: "sferik"}).to_return(body: fixture("sferik.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.unmute("sferik")

      assert_requested(a_post("/1.1/mutes/users/destroy.json").with(body: {screen_name: "sferik"}))
    end

    it "returns an array of un-muteed users" do
      users = @client.unmute("sferik")

      assert_kind_of(Array, users)
      assert_kind_of(Twitter::User, users.first)
      assert_equal(7_505_382, users.first.id)
    end
  end

  describe "#muted" do
    before do
      stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.muted

      assert_requested(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"}))
    end

    it "returns an array of user objects that the authenticating user is muting" do
      muted = @client.muted

      assert_kind_of(Twitter::Cursor, muted)
      assert_kind_of(Twitter::User, muted.first)
      assert_equal(7_505_382, muted.first.id)
    end

    describe "with options passed" do
      before do
        stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1", skip_status: "true"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.muted(skip_status: true)

        assert_requested(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1", skip_status: "true"}))
      end
    end

    describe "with each" do
      before do
        stub_get("/1.1/mutes/users/list.json").with(query: {cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.muted.each {}

        assert_requested(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/mutes/users/list.json").with(query: {cursor: "1322801608223717003"}))
      end
    end
  end

  describe "#muted_ids" do
    before do
      stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.muted_ids

      assert_requested(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"}))
    end

    it "returns an array of numeric user IDs the authenticating user is muting" do
      muted_ids = @client.muted_ids

      assert_kind_of(Twitter::Cursor, muted_ids)
      assert_equal(20_009_713, muted_ids.first)
    end

    describe "with a user passed" do
      before do
        stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1", user_id: "7505382"}).to_return(body: fixture("ids_list.json"), headers: json_headers)
      end

      it "passes user_id to the request" do
        @client.muted_ids(7_505_382)

        assert_requested(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1", user_id: "7505382"}))
      end
    end

    describe "with each" do
      before do
        stub_get("/1.1/mutes/users/ids.json").with(query: {cursor: "1305102810874389703"}).to_return(body: fixture("ids_list2.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.muted_ids.each {}

        assert_requested(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "-1"}))
        assert_requested(a_get("/1.1/mutes/users/ids.json").with(query: {cursor: "1305102810874389703"}))
      end
    end
  end

  describe "Twitter::REST::Utils helper behavior" do
    let(:utils_client_class) do
      Class.new do
        include Twitter::REST::Utils

        attr_accessor :credentials_id

        def verify_credentials(skip_status:)
          raise ArgumentError, "skip_status must be true" unless skip_status

          Struct.new(:id).new(credentials_id)
        end
      end
    end

    let(:utils_client) do
      utils_client_class.new.tap do |instance|
        instance.credentials_id = 4_242
      end
    end

    describe "#extract_id" do
      it "extracts integer IDs from each supported input type" do
        identity = Twitter::Identity.new(id: 99)
        uri = URI.parse("https://twitter.com/sferik/123")
        addressable_uri = Addressable::URI.parse("https://twitter.com/sferik/456")

        assert_equal(1, utils_client.send(:extract_id, 1))
        assert_equal(2, utils_client.send(:extract_id, "https://twitter.com/sferik/2"))
        assert_equal(123, utils_client.send(:extract_id, uri))
        assert_equal(456, utils_client.send(:extract_id, addressable_uri))
        assert_equal(99, utils_client.send(:extract_id, identity))
      end
    end

    describe "#perform_get" do
      it "delegates to perform_request with default empty options" do
        utils_client.stub(:perform_request, lambda { |request_method, path, options|
          assert_equal(:get, request_method)
          assert_equal("/path", path)
          assert_empty(options)
          :ok
        }) do
          assert_equal(:ok, utils_client.send(:perform_get, "/path"))
        end
      end
    end

    describe "#perform_post" do
      it "delegates to perform_request with default empty options" do
        utils_client.stub(:perform_request, lambda { |request_method, path, options|
          assert_equal(:post, request_method)
          assert_equal("/path", path)
          assert_empty(options)
          :ok
        }) do
          assert_equal(:ok, utils_client.send(:perform_post, "/path"))
        end
      end
    end

    describe "#perform_get_with_cursor" do
      it "uses merge_default_cursor! when no_default_cursor is false" do
        options = {no_default_cursor: false}
        request = Object.new
        merge_default_cursor_called = false

        utils_client.stub(:merge_default_cursor!, lambda { |opts|
          merge_default_cursor_called = true

          assert_equal(options, opts)
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, request_method, path, opts|
            assert_equal(utils_client, client)
            assert_equal(:get, request_method)
            assert_equal("/path", path)
            assert_equal(options, opts)
            request
          }) do
            Twitter::Cursor.stub(:new, lambda { |collection_name, klass, req, limit|
              assert_equal(:friends, collection_name)
              assert_nil(klass)
              assert_equal(request, req)
              assert_nil(limit)
              :cursor
            }) do
              assert_equal(:cursor, utils_client.send(:perform_get_with_cursor, "/path", options, :friends))
            end
          end
        end

        assert(merge_default_cursor_called)
      end

      it "removes no_default_cursor and passes limit explicitly to Cursor" do
        options = {no_default_cursor: true, limit: 10}
        request = Object.new
        merge_default_cursor_called = false

        utils_client.stub(:merge_default_cursor!, lambda { |_opts|
          merge_default_cursor_called = true
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, request_method, path, opts|
            assert_equal(utils_client, client)
            assert_equal(:get, request_method)
            assert_equal("/path", path)
            assert_empty(opts)
            request
          }) do
            Twitter::Cursor.stub(:new, lambda { |collection_name, klass, req, limit|
              assert_equal(:friends, collection_name)
              assert_nil(klass)
              assert_equal(request, req)
              assert_equal(10, limit)
              :cursor
            }) do
              assert_equal(:cursor, utils_client.send(:perform_get_with_cursor, "/path", options, :friends))
            end
          end
        end

        refute(merge_default_cursor_called)
        assert_empty(options)
      end
    end

    describe "#users_from_response" do
      it "falls back to the current user_id when no user_id/screen_name option is present" do
        utils_client.stub(:user_id, 55) do
          utils_client.stub(:perform_request_with_objects, lambda { |request_method, path, options, klass|
            assert_equal(:get, request_method)
            assert_equal("/users", path)
            assert_equal({user_id: 55}, options)
            assert_equal(Twitter::User, klass)
            []
          }) do
            assert_empty(utils_client.send(:users_from_response, :get, "/users", []))
          end
        end
      end

      it "does not inject user_id when screen_name is already provided" do
        options = {screen_name: "sferik"}

        utils_client.stub(:user_id, -> { flunk("user_id should not be called") }) do
          utils_client.stub(:perform_request_with_objects, lambda { |request_method, path, passed_options, klass|
            assert_equal(:get, request_method)
            assert_equal("/users", path)
            assert_equal(options, passed_options)
            assert_equal(Twitter::User, klass)
            []
          }) do
            utils_client.send(:users_from_response, :get, "/users", [options])
          end
        end
      end

      it "does not inject user_id when user_id is already provided" do
        options = {user_id: 11}

        utils_client.stub(:user_id, -> { flunk("user_id should not be called") }) do
          utils_client.stub(:perform_request_with_objects, lambda { |request_method, path, passed_options, klass|
            assert_equal(:get, request_method)
            assert_equal("/users", path)
            assert_equal(options, passed_options)
            assert_equal(Twitter::User, klass)
            []
          }) do
            utils_client.send(:users_from_response, :get, "/users", [options])
          end
        end
      end
    end

    describe "#cursor_from_response_with_user" do
      it "injects current user_id when neither user_id nor screen_name is provided" do
        utils_client.stub(:user_id, 77) do
          utils_client.stub(:perform_get_with_cursor, lambda { |path, options, collection_name, klass|
            assert_equal("/followers", path)
            assert_equal({user_id: 77}, options)
            assert_equal(:users, collection_name)
            assert_equal(Twitter::User, klass)
            :cursor
          }) do
            assert_equal(:cursor, utils_client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", []))
          end
        end
      end

      it "keeps explicit screen_name untouched" do
        options = {screen_name: "sferik"}

        utils_client.stub(:user_id, -> { flunk("user_id should not be called") }) do
          utils_client.stub(:perform_get_with_cursor, lambda { |path, passed_options, collection_name, klass|
            assert_equal("/followers", path)
            assert_equal(options, passed_options)
            assert_equal(:users, collection_name)
            assert_equal(Twitter::User, klass)
            :cursor
          }) do
            assert_equal(:cursor, utils_client.send(:cursor_from_response_with_user, :users, Twitter::User, "/followers", [options]))
          end
        end
      end
    end

    describe "#user_id?" do
      it "is false until user_id is memoized and true afterwards" do
        refute(utils_client.send(:user_id?))

        utils_client.send(:user_id)

        assert(utils_client.send(:user_id?))
      end
    end

    describe "#merge_default_cursor!" do
      it "assigns the default cursor when cursor is nil" do
        options = {cursor: nil}
        utils_client.send(:merge_default_cursor!, options)

        assert_equal(Twitter::REST::Utils::DEFAULT_CURSOR, options[:cursor])
      end

      it "assigns the default cursor when cursor is false" do
        options = {cursor: false}
        utils_client.send(:merge_default_cursor!, options)

        assert_equal(Twitter::REST::Utils::DEFAULT_CURSOR, options[:cursor])
      end
    end

    describe "#merge_user" do
      it "returns a new hash and keeps the original unchanged" do
        original = {trim_user: true}

        result = utils_client.send(:merge_user, original, 123)

        assert_equal({trim_user: true, user_id: 123}, result)
        assert_equal({trim_user: true}, original)
      end

      it "respects an explicit prefix" do
        result = utils_client.send(:merge_user, {}, 123, "target")

        assert_equal({target_user_id: 123}, result)
      end
    end

    describe "#merge_user!" do
      it "extracts screen_name from URI-like inputs" do
        hash = {}
        utils_client.send(:merge_user!, hash, URI.parse("https://twitter.com/sferik"))

        assert_equal({screen_name: "sferik"}, hash)
      end
    end

    describe "#set_compound_key" do
      it "uses a nil prefix by default" do
        hash = {}

        assert_equal({screen_name: "sferik"}, utils_client.send(:set_compound_key, "screen_name", "sferik", hash))
      end
    end

    describe "#merge_users" do
      it "returns a copy and does not mutate the input hash" do
        original = {trim_user: true}

        result = utils_client.send(:merge_users, original, [1, "sferik"])

        assert_equal({trim_user: true}, original)
        assert_equal({trim_user: true, user_id: "1", screen_name: "sferik"}, result)
      end
    end

    describe "#merge_users!" do
      it "deduplicates users before collecting IDs and screen_names" do
        hash = {}
        users = [1, 1, "sferik", "sferik"]

        utils_client.send(:merge_users!, hash, users)

        assert_equal("1", hash[:user_id])
        assert_equal("sferik", hash[:screen_name])
      end
    end

    describe "#collect_users" do
      it "collects IDs and screen names from all supported types" do
        users = [
          1,
          Twitter::User.new(id: 2),
          "sferik",
          URI.parse("https://twitter.com/erik"),
          Addressable::URI.parse("https://twitter.com/alice")
        ]

        user_ids, screen_names = utils_client.send(:collect_users, users)

        assert_equal([1, 2], user_ids)
        assert_equal(%w[sferik erik alice], screen_names)
      end
    end
  end

  describe "Twitter::REST::UploadUtils helper behavior" do
    let(:upload_client_class) do
      Class.new do
        include Twitter::REST::UploadUtils

        attr_accessor :timeouts
      end
    end

    let(:upload_client) { upload_client_class.new }

    describe "#upload" do
      it "uses multipart upload with :media key for non-chunked uploads" do
        media = fixture_file("pbjt.gif")
        response = {media_id: 1}
        request = Object.new
        request.define_singleton_method(:perform) { response }

        Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
          assert_equal(upload_client, client)
          assert_equal(:multipart_post, method)
          assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
          assert_equal(:media, options[:key])
          assert_equal(media, options[:file])
          request
        }) do
          File.stub(:size, lambda { |path|
            assert_equal(media, path)
            1_024
          }) do
            assert_equal(response, upload_client.send(:upload, media))
          end
        end
      end

      it "chunks gif uploads only when size is above 5,000,000 bytes" do
        media = fixture_file("pbjt.gif")
        chunk_upload_called = false

        upload_client.stub(:chunk_upload, lambda { |file, media_type, category|
          chunk_upload_called = true

          assert_equal(media, file)
          assert_equal("image/gif", media_type)
          assert_equal("tweet_gif", category)
          :chunked
        }) do
          File.stub(:size, lambda { |path|
            assert_equal(media, path)
            5_000_001
          }) do
            assert_equal(:chunked, upload_client.send(:upload, media))
          end
        end

        assert(chunk_upload_called)
      end

      it "does not chunk a gif upload at exactly 5,000,000 bytes" do
        media = fixture_file("pbjt.gif")
        request = Object.new
        request.define_singleton_method(:perform) { {media_id: 1} }

        chunk_upload_called = false
        upload_client.stub(:chunk_upload, lambda { |_file, _media_type, _category|
          chunk_upload_called = true

          flunk("chunk_upload should not be called")
        }) do
          Twitter::REST::Request.stub(:new, lambda { |_client, _method, _path, _options|
            request
          }) do
            File.stub(:size, lambda { |path|
              assert_equal(media, path)
              5_000_000
            }) do
              upload_client.send(:upload, media)
            end
          end
        end

        refute(chunk_upload_called)
      end

      it "does not chunk large non-gif files" do
        media = fixture_file("we_concept_bg2.png")
        request = Object.new
        request.define_singleton_method(:perform) { {media_id: 1} }

        chunk_upload_called = false
        upload_client.stub(:chunk_upload, lambda { |_file, _media_type, _category|
          chunk_upload_called = true

          flunk("chunk_upload should not be called")
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
            assert_equal(upload_client, client)
            assert_equal(:multipart_post, method)
            assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
            assert_equal(:media, options[:key])
            assert_equal(media, options[:file])
            request
          }) do
            File.stub(:size, lambda { |path|
              assert_equal(media, path)
              8_000_000
            }) do
              upload_client.send(:upload, media)
            end
          end
        end

        refute(chunk_upload_called)
      end
    end

    describe "#chunk_upload" do
      it "initializes, appends, closes media, and finalizes with expected arguments" do
        media = Object.new
        media.define_singleton_method(:size) { 123_456 }
        media_closed = false
        media.define_singleton_method(:close) { media_closed = true }
        init_response = {media_id: 42}
        init_request = Object.new
        init_request.define_singleton_method(:perform) { init_response }
        timeout_args = nil
        append_args = nil
        finalize_arg = nil

        Timeout.stub(:timeout, lambda { |duration, error_class, &block|
          timeout_args = [duration, error_class]
          block.call
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
            assert_equal(upload_client, client)
            assert_equal(:post, method)
            assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
            assert_equal("INIT", options[:command])
            assert_equal("video/mp4", options[:media_type])
            assert_equal("tweet_video", options[:media_category])
            assert_equal(123_456, options[:total_bytes])
            init_request
          }) do
            upload_client.stub(:append_media, lambda { |media_file, media_id|
              append_args = [media_file, media_id]
              nil
            }) do
              upload_client.stub(:finalize_media, lambda { |media_id|
                finalize_arg = media_id
                :finalized
              }) do
                assert_equal(:finalized, upload_client.send(:chunk_upload, media, "video/mp4", "tweet_video"))
              end
            end
          end
        end

        assert_equal([nil, Twitter::Error::TimeoutError], timeout_args)
        assert_equal([media, 42], append_args)
        assert_equal(42, finalize_arg)
        assert(media_closed)
      end
    end

    describe "#append_media" do
      it "reads 5,000,000-byte chunks and uploads StringIO chunks with :media key" do
        media = Object.new
        eof_calls = 0
        media.define_singleton_method(:eof?) do
          eof_calls += 1
          eof_calls > 1
        end
        read_sizes = []
        media.define_singleton_method(:read) do |size|
          read_sizes << size
          "abc"
        end

        request = Object.new
        perform_called = false
        request.define_singleton_method(:perform) { perform_called = true }

        Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
          assert_equal(upload_client, client)
          assert_equal(:multipart_post, method)
          assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
          assert_equal("APPEND", options[:command])
          assert_equal(9, options[:media_id])
          assert_equal(0, options[:segment_index])
          assert_equal(:media, options[:key])
          assert_kind_of(StringIO, options[:file])
          assert_equal("abc", options[:file].read)
          request
        }) do
          upload_client.send(:append_media, media, 9)
        end

        assert_equal([5_000_000], read_sizes)
        assert(perform_called)
      end
    end

    describe "#finalize_media" do
      it "returns immediately when processing state is failed" do
        failed = {processing_info: {state: "failed"}}
        request = Object.new
        request.define_singleton_method(:perform) { failed }
        sleep_called = false

        upload_client.stub(:sleep, lambda { |_seconds|
          sleep_called = true

          flunk("sleep should not be called")
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
            assert_equal(upload_client, client)
            assert_equal(:post, method)
            assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
            assert_equal({command: "FINALIZE", media_id: 77}, options)
            request
          }) do
            assert_equal(failed, upload_client.send(:finalize_media, 77))
          end
        end

        refute(sleep_called)
      end

      it "polls status until upload processing succeeds" do
        pending = {processing_info: {state: "pending", check_after_secs: 2}}
        succeeded = {processing_info: {state: "succeeded"}}
        post_request = Object.new
        post_request.define_singleton_method(:perform) { pending }
        get_request = Object.new
        get_request.define_singleton_method(:perform) { succeeded }
        request_calls = []
        sleep_args = []

        upload_client.stub(:sleep, lambda { |seconds|
          sleep_args << seconds
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
            assert_equal(upload_client, client)
            assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
            request_calls << [method, options]

            if method == :post
              post_request
            else
              get_request
            end
          }) do
            assert_equal(succeeded, upload_client.send(:finalize_media, 88))
          end
        end

        assert_equal([2], sleep_args)
        assert_equal([:post, {command: "FINALIZE", media_id: 88}], request_calls[0])
        assert_equal([:get, {command: "STATUS", media_id: 88}], request_calls[1])
      end

      it "handles pending processing_info without an explicit state key" do
        pending_without_state = {processing_info: {check_after_secs: 1}}
        succeeded = {processing_info: {state: "succeeded"}}
        post_request = Object.new
        post_request.define_singleton_method(:perform) { pending_without_state }
        get_request = Object.new
        get_request.define_singleton_method(:perform) { succeeded }
        request_calls = []
        sleep_args = []

        upload_client.stub(:sleep, lambda { |seconds|
          sleep_args << seconds
        }) do
          Twitter::REST::Request.stub(:new, lambda { |client, method, path, options|
            assert_equal(upload_client, client)
            assert_equal("https://upload.twitter.com/1.1/media/upload.json", path)
            request_calls << [method, options]

            if method == :post
              post_request
            else
              get_request
            end
          }) do
            assert_equal(succeeded, upload_client.send(:finalize_media, 89))
          end
        end

        assert_equal([1], sleep_args)
        assert_equal([:post, {command: "FINALIZE", media_id: 89}], request_calls[0])
        assert_equal([:get, {command: "STATUS", media_id: 89}], request_calls[1])
      end
    end
  end
end
