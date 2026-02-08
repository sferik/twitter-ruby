require "test_helper"

describe Twitter::REST::Lists do
  before do
    @client = build_rest_client
  end

  describe "private path parsing helpers" do
    describe "#merge_slug_and_owner!" do
      it "extracts owner_screen_name as a string when owner and slug are in the path" do
        hash = {}

        @client.send(:merge_slug_and_owner!, hash, "sferik/presidents")

        assert_equal({owner_screen_name: "sferik", slug: "presidents"}, hash)
        assert_kind_of(String, hash[:owner_screen_name])
      end
    end

    describe "#merge_list!" do
      it "leaves the hash unchanged for unsupported list input types" do
        hash = {existing: true}

        @client.send(:merge_list!, hash, Object.new)

        assert_equal({existing: true}, hash)
      end
    end
  end

  describe "#lists" do
    before do
      stub_get("/1.1/lists/list.json").to_return(body: fixture("lists.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.lists

      assert_requested(a_get("/1.1/lists/list.json"))
    end

    it "returns the requested list" do
      lists = @client.lists

      assert_kind_of(Array, lists)
      assert_kind_of(Twitter::List, lists.first)
      assert_equal("Rubyists", lists.first.name)
    end
  end

  describe "#list_timeline" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/statuses.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_timeline("sferik", "presidents")

        assert_requested(a_get("/1.1/lists/statuses.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}))
      end

      it "returns the timeline for members of the specified list" do
        tweets = @client.list_timeline("sferik", "presidents")

        assert_kind_of(Array, tweets)
        assert_kind_of(Twitter::Tweet, tweets.first)
        assert_equal("Happy Birthday @imdane. Watch out for those @rally pranksters!", tweets.first.text)
      end

      describe "with a URI object passed" do
        it "requests the correct resource" do
          list = URI.parse("https://twitter.com/sferik/presidents")
          @client.list_timeline(list)

          assert_requested(a_get("/1.1/lists/statuses.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}))
        end
      end

      describe "with an Addressable::URI object passed" do
        it "requests the correct resource" do
          list = Addressable::URI.parse("https://twitter.com/sferik/presidents")
          @client.list_timeline(list)

          assert_requested(a_get("/1.1/lists/statuses.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}))
        end
      end

      describe "with URI objects passed" do
        it "requests the correct resource" do
          user = URI.parse("https://twitter.com/sferik")
          list = URI.parse("https://twitter.com/sferik/presidents")
          @client.list_timeline(user, list)

          assert_requested(a_get("/1.1/lists/statuses.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}))
        end
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/statuses.json").with(query: {owner_id: "7505382", slug: "presidents"}).to_return(body: fixture("statuses.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_timeline("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/statuses.json").with(query: {owner_id: "7505382", slug: "presidents"}))
      end
    end
  end

  describe "#remove_list_member" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_member("sferik", "presidents", 813_286)

        assert_requested(a_post("/1.1/lists/members/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}))
      end

      it "returns the list" do
        list = @client.remove_list_member("sferik", "presidents", 813_286)

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/members/destroy.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_member("presidents", 813_286)

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/members/destroy.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286"}))
      end
    end
  end

  describe "#memberships" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/memberships.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("memberships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.memberships("sferik")

        assert_requested(a_get("/1.1/lists/memberships.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns the lists the specified user has been added to" do
        memberships = @client.memberships("sferik")

        assert_kind_of(Twitter::Cursor, memberships)
        assert_kind_of(Twitter::List, memberships.first)
        assert_equal("developer", memberships.first.name)
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(query: {screen_name: "sferik", cursor: "1401037770457540712"}).to_return(body: fixture("memberships2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.memberships("sferik").each {}

          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {screen_name: "sferik", cursor: "1401037770457540712"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("memberships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.memberships(7_505_382)

        assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}).to_return(body: fixture("memberships2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.memberships(7_505_382).each {}

          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}))
        end
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("memberships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.memberships

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}).to_return(body: fixture("memberships2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.memberships.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/memberships.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}))
        end
      end
    end
  end

  describe "#list_subscribers" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscribers.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscribers("sferik", "presidents")

        assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}))
      end

      it "returns the subscribers of the specified list" do
        list_subscribers = @client.list_subscribers("sferik", "presidents")

        assert_kind_of(Twitter::Cursor, list_subscribers)
        assert_kind_of(Twitter::User, list_subscribers.first)
        assert_equal(7_505_382, list_subscribers.first.id)
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_subscribers("sferik", "presidents").each {}

          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscribers(7_505_382, "presidents")

        assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_subscribers(7_505_382, "presidents").each {}

          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscribers("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_subscribers("presidents").each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscribers.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end
  end

  describe "#list_subscribe" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/subscribers/create.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscribe("sferik", "presidents")

        assert_requested(a_post("/1.1/lists/subscribers/create.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}))
      end

      it "returns the specified list" do
        list = @client.list_subscribe("sferik", "presidents")

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/subscribers/create.json").with(body: {owner_id: "7505382", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscribe("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/subscribers/create.json").with(body: {owner_id: "7505382", slug: "presidents"}))
      end
    end
  end

  describe "#list_subscriber?" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "18755393"}).to_return(body: fixture("not_found.json"), status: 404, headers: json_headers)
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "12345678"}).to_return(body: fixture("not_found.json"), status: 403, headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 813_286)

        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}))
      end

      it "returns true if the specified user subscribes to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 813_286)

        assert_true(list_subscriber)
      end

      it "returns false if the specified user does not subscribe to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 18_755_393)

        assert_false(list_subscriber)
      end

      it "returns false if user does not exist" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 12_345_678)

        assert_false(list_subscriber)
      end
    end

    describe "with a owner ID passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "12345678", slug: "presidents", user_id: "813286"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscriber?(12_345_678, "presidents", 813_286)

        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "12345678", slug: "presidents", user_id: "813286"}))
      end
    end

    describe "with a list ID passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678", user_id: "813286"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscriber?("sferik", 12_345_678, 813_286)

        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678", user_id: "813286"}))
      end
    end

    describe "with a list object passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "7505382", list_id: "12345678", user_id: "813286"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        list = Twitter::List.new(id: 12_345_678, user: {id: 7_505_382, screen_name: "sferik"})
        @client.list_subscriber?(list, 813_286)

        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "7505382", list_id: "12345678", user_id: "813286"}))
      end
    end

    describe "with a screen name passed for user_to_check" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", screen_name: "erebor"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", "erebor")

        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", screen_name: "erebor"}))
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "7505382", slug: "presidents", user_id: "813286"}).to_return(body: fixture("sferik.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_subscriber?("presidents", 813_286)

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/subscribers/show.json").with(query: {owner_id: "7505382", slug: "presidents", user_id: "813286"}))
      end
    end
  end

  describe "#list_unsubscribe" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/subscribers/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_unsubscribe("sferik", "presidents")

        assert_requested(a_post("/1.1/lists/subscribers/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}))
      end

      it "returns the specified list" do
        list = @client.list_unsubscribe("sferik", "presidents")

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/subscribers/destroy.json").with(body: {owner_id: "7505382", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_unsubscribe("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/subscribers/destroy.json").with(body: {owner_id: "7505382", slug: "presidents"}))
      end
    end
  end

  describe "#add_list_members" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_members("sferik", "presidents", [813_286, 18_755_393])

        assert_requested(a_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}))
      end

      it "returns the list" do
        list = @client.add_list_members("sferik", "presidents", [813_286, 18_755_393])

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393", screen_name: "pengwynn,erebor"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_members("sferik", "presidents", [813_286, "pengwynn", 18_755_393, "erebor"])

        assert_requested(a_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393", screen_name: "pengwynn,erebor"}))
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/members/create_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_members("presidents", [813_286, 18_755_393])

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/members/create_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}))
      end
    end

    describe "with options hash as last argument" do
      before do
        stub_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_members("sferik", "presidents", [813_286, 18_755_393], {})

        assert_requested(a_post("/1.1/lists/members/create_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}))
      end
    end
  end

  describe "#list_member?" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
        stub_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "65493023"}).to_return(body: fixture("not_found.json"), status: 404, headers: json_headers)
        stub_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "12345678"}).to_return(body: fixture("not_found.json"), status: 403, headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", 813_286)

        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}))
      end

      it "returns true if user is a list member" do
        list_member = @client.list_member?("sferik", "presidents", 813_286)

        assert_true(list_member)
      end

      it "returns false if user is not a list member" do
        list_member = @client.list_member?("sferik", "presidents", 65_493_023)

        assert_false(list_member)
      end

      it "returns false if user does not exist" do
        list_member = @client.list_member?("sferik", "presidents", 12_345_678)

        assert_false(list_member)
      end
    end

    describe "with an owner ID passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(query: {owner_id: "12345678", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_member?(12_345_678, "presidents", 813_286)

        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_id: "12345678", slug: "presidents", user_id: "813286"}))
      end
    end

    describe "with a list ID passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_member?("sferik", 12_345_678, 813_286)

        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678", user_id: "813286"}))
      end
    end

    describe "with a list object passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(query: {owner_id: "7505382", list_id: "12345678", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        list = Twitter::List.new(id: 12_345_678, user: {id: 7_505_382, screen_name: "sferik"})
        @client.list_member?(list, 813_286)

        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_id: "7505382", list_id: "12345678", user_id: "813286"}))
      end
    end

    describe "with a screen name passed for user_to_check" do
      before do
        stub_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", screen_name: "erebor"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", "erebor")

        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents", screen_name: "erebor"}))
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/members/show.json").with(query: {owner_id: "7505382", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_member?("presidents", 813_286)

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/members/show.json").with(query: {owner_id: "7505382", slug: "presidents", user_id: "813286"}))
      end
    end
  end

  describe "#list_members" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/members.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_members("sferik", "presidents")

        assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}))
      end

      it "returns the members of the specified list" do
        list_members = @client.list_members("sferik", "presidents")

        assert_kind_of(Twitter::Cursor, list_members)
        assert_kind_of(Twitter::User, list_members.first)
        assert_equal(7_505_382, list_members.first.id)
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_members("sferik", "presidents").each {}

          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_screen_name: "sferik", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_members(7_505_382, "presidents")

        assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_members(7_505_382, "presidents").each {}

          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}).to_return(body: fixture("users_list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_members("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}).to_return(body: fixture("users_list2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.list_members("presidents").each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/members.json").with(query: {owner_id: "7505382", slug: "presidents", cursor: "1322801608223717003"}))
        end
      end
    end
  end

  describe "#add_list_member" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/create.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_member("sferik", "presidents", 813_286)

        assert_requested(a_post("/1.1/lists/members/create.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286"}))
      end

      it "returns the list" do
        list = @client.add_list_member("sferik", "presidents", 813_286)

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/members/create.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.add_list_member("presidents", 813_286)

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/members/create.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286"}))
      end
    end
  end

  describe "#destroy_list" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.destroy_list("sferik", "presidents")

        assert_requested(a_post("/1.1/lists/destroy.json").with(body: {owner_screen_name: "sferik", slug: "presidents"}))
      end

      it "returns the deleted list" do
        list = @client.destroy_list("sferik", "presidents")

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/destroy.json").with(body: {owner_id: "7505382", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.destroy_list("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/destroy.json").with(body: {owner_id: "7505382", slug: "presidents"}))
      end
    end

    describe "with a list ID passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(body: {owner_screen_name: "sferik", list_id: "12345678"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.destroy_list("sferik", 12_345_678)

        assert_requested(a_post("/1.1/lists/destroy.json").with(body: {owner_screen_name: "sferik", list_id: "12345678"}))
      end
    end

    describe "with a list object passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(body: {owner_id: "7505382", list_id: "12345678"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        list = Twitter::List.new(id: 12_345_678, user: {id: 7_505_382, screen_name: "sferik"})
        @client.destroy_list(list)

        assert_requested(a_post("/1.1/lists/destroy.json").with(body: {owner_id: "7505382", list_id: "12345678"}))
      end
    end
  end

  describe "#list_update" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/update.json").with(body: {owner_screen_name: "sferik", slug: "presidents", description: "Presidents of the United States of America"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_update("sferik", "presidents", description: "Presidents of the United States of America")

        assert_requested(a_post("/1.1/lists/update.json").with(body: {owner_screen_name: "sferik", slug: "presidents", description: "Presidents of the United States of America"}))
      end

      it "returns the updated list" do
        list = @client.list_update("sferik", "presidents", description: "Presidents of the United States of America")

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/update.json").with(body: {owner_id: "7505382", slug: "presidents", description: "Presidents of the United States of America"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_update("presidents", description: "Presidents of the United States of America")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/update.json").with(body: {owner_id: "7505382", slug: "presidents", description: "Presidents of the United States of America"}))
      end
    end

    describe "with a list ID passed" do
      before do
        stub_post("/1.1/lists/update.json").with(body: {owner_screen_name: "sferik", list_id: "12345678", description: "Presidents of the United States of America"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list_update("sferik", 12_345_678, description: "Presidents of the United States of America")

        assert_requested(a_post("/1.1/lists/update.json").with(body: {owner_screen_name: "sferik", list_id: "12345678", description: "Presidents of the United States of America"}))
      end
    end

    describe "with a list object passed" do
      before do
        stub_post("/1.1/lists/update.json").with(body: {owner_id: "7505382", list_id: "12345678", description: "Presidents of the United States of America"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        list = Twitter::List.new(id: 12_345_678, user: {id: 7_505_382, screen_name: "sferik"})
        @client.list_update(list, description: "Presidents of the United States of America")

        assert_requested(a_post("/1.1/lists/update.json").with(body: {owner_id: "7505382", list_id: "12345678", description: "Presidents of the United States of America"}))
      end
    end
  end

  describe "#create_list" do
    before do
      stub_post("/1.1/lists/create.json").with(body: {name: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.create_list("presidents")

      assert_requested(a_post("/1.1/lists/create.json").with(body: {name: "presidents"}))
    end

    it "returns the created list" do
      list = @client.create_list("presidents")

      assert_kind_of(Twitter::List, list)
      assert_equal("presidents", list.name)
    end

    describe "with options" do
      before do
        stub_post("/1.1/lists/create.json").with(body: {name: "presidents", mode: "private"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "passes options to the request" do
        @client.create_list("presidents", mode: "private")

        assert_requested(a_post("/1.1/lists/create.json").with(body: {name: "presidents", mode: "private"}))
      end
    end
  end

  describe "#list" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list("sferik", "presidents")

        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_screen_name: "sferik", slug: "presidents"}))
      end

      it "returns the updated list" do
        list = @client.list("sferik", "presidents")

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/lists/show.json").with(query: {owner_id: "12345678", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list(12_345_678, "presidents")

        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_id: "12345678", slug: "presidents"}))
      end
    end

    describe "with a user object passed" do
      before do
        stub_get("/1.1/lists/show.json").with(query: {owner_id: "12345678", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        user = Twitter::User.new(id: "12345678")
        @client.list(user, "presidents")

        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_id: "12345678", slug: "presidents"}))
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/show.json").with(query: {owner_id: "7505382", slug: "presidents"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list("presidents")

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_id: "7505382", slug: "presidents"}))
      end
    end

    describe "with a list ID passed" do
      before do
        stub_get("/1.1/lists/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.list("sferik", 12_345_678)

        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_screen_name: "sferik", list_id: "12345678"}))
      end
    end

    describe "with a list object passed" do
      before do
        stub_get("/1.1/lists/show.json").with(query: {owner_id: "7505382", list_id: "12345678"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        list = Twitter::List.new(id: 12_345_678, user: {id: 7_505_382, screen_name: "sferik"})
        @client.list(list)

        assert_requested(a_get("/1.1/lists/show.json").with(query: {owner_id: "7505382", list_id: "12345678"}))
      end
    end
  end

  describe "#subscriptions" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscriptions.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("subscriptions.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.subscriptions("sferik")

        assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns the lists the specified user follows" do
        subscriptions = @client.subscriptions("sferik")

        assert_kind_of(Twitter::Cursor, subscriptions)
        assert_kind_of(Twitter::List, subscriptions.first)
        assert_equal("Rubyists", subscriptions.first.name)
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(query: {screen_name: "sferik", cursor: "1401037770457540712"}).to_return(body: fixture("subscriptions2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.subscriptions("sferik").each {}

          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {screen_name: "sferik", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {screen_name: "sferik", cursor: "1401037770457540712"}))
        end
      end
    end

    describe "with a user ID passed" do
      before do
        stub_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("subscriptions.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.subscriptions(7_505_382)

        assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}).to_return(body: fixture("subscriptions2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.subscriptions(7_505_382).each {}

          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}))
        end
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("subscriptions.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.subscriptions

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      describe "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}).to_return(body: fixture("subscriptions2.json"), headers: json_headers)
        end

        it "requests the correct resource" do
          @client.subscriptions.each {}

          assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "-1"}))
          assert_requested(a_get("/1.1/lists/subscriptions.json").with(query: {user_id: "7505382", cursor: "1401037770457540712"}))
        end
      end
    end
  end

  describe "#remove_list_members" do
    describe "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_members("sferik", "presidents", [813_286, 18_755_393])

        assert_requested(a_post("/1.1/lists/members/destroy_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393"}))
      end

      it "returns the list" do
        list = @client.remove_list_members("sferik", "presidents", [813_286, 18_755_393])

        assert_kind_of(Twitter::List, list)
        assert_equal("presidents", list.name)
      end
    end

    describe "with a user ID passed" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_members(7_505_382, "presidents", [813_286, 18_755_393])

        assert_requested(a_post("/1.1/lists/members/destroy_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}))
      end
    end

    describe "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393", screen_name: "pengwynn,erebor"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_members("sferik", "presidents", [813_286, "pengwynn", 18_755_393, "erebor"])

        assert_requested(a_post("/1.1/lists/members/destroy_all.json").with(body: {owner_screen_name: "sferik", slug: "presidents", user_id: "813286,18755393", screen_name: "pengwynn,erebor"}))
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_post("/1.1/lists/members/destroy_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}).to_return(body: fixture("list.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.remove_list_members("presidents", [813_286, 18_755_393])

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_post("/1.1/lists/members/destroy_all.json").with(body: {owner_id: "7505382", slug: "presidents", user_id: "813286,18755393"}))
      end
    end
  end

  describe "#owned_lists" do
    describe "with a screen name passed" do
      before do
        stub_get("/1.1/lists/ownerships.json").with(query: {screen_name: "sferik", cursor: "-1"}).to_return(body: fixture("ownerships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.owned_lists("sferik")

        assert_requested(a_get("/1.1/lists/ownerships.json").with(query: {screen_name: "sferik", cursor: "-1"}))
      end

      it "returns the requested list" do
        lists = @client.owned_lists("sferik")

        assert_kind_of(Twitter::Cursor, lists)
        assert_kind_of(Twitter::List, lists.first)
        assert_equal("My favstar.fm list", lists.first.name)
      end
    end

    describe "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}).to_return(body: fixture("sferik.json"), headers: json_headers)
        stub_get("/1.1/lists/ownerships.json").with(query: {user_id: "7505382", cursor: "-1"}).to_return(body: fixture("ownerships.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.owned_lists

        assert_requested(a_get("/1.1/account/verify_credentials.json").with(query: {skip_status: "true"}))
        assert_requested(a_get("/1.1/lists/ownerships.json").with(query: {user_id: "7505382", cursor: "-1"}))
      end

      it "returns the requested list" do
        lists = @client.owned_lists

        assert_kind_of(Twitter::Cursor, lists)
        assert_kind_of(Twitter::List, lists.first)
        assert_equal("My favstar.fm list", lists.first.name)
      end
    end
  end
end
