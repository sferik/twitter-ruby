require 'helper'

describe Twitter::REST::API::Lists do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
  end

  describe "#lists" do
    before do
      stub_get("/1.1/lists/list.json").to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.lists
      expect(a_get("/1.1/lists/list.json")).to have_been_made
    end
    it "returns the requested list" do
      lists = @client.lists
      expect(lists).to be_an Array
      expect(lists.first).to be_a Twitter::List
      expect(lists.first.name).to eq("Rubyists")
    end
  end

  describe "#list_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_timeline("sferik", "presidents")
        expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
      it "returns the timeline for members of the specified list" do
        tweets = @client.list_timeline("sferik", "presidents")
        expect(tweets).to be_an Array
        expect(tweets.first).to be_a Twitter::Tweet
        expect(tweets.first.text).to eq("Happy Birthday @imdane. Watch out for those @rally pranksters!")
      end
      context "with a URI object passed" do
        it "requests the correct resource" do
          list = URI.parse("https://twitter.com/sferik/presidents")
          @client.list_timeline(list)
          expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
        end
      end
      context "with a URI string passed" do
        it "requests the correct resource" do
          @client.list_timeline("https://twitter.com/sferik/presidents")
          expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
        end
      end
      context "with URI objects passed" do
        it "requests the correct resource" do
          user = URI.parse("https://twitter.com/sferik")
          list = URI.parse("https://twitter.com/sferik/presidents")
          @client.list_timeline(user, list)
          expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
        end
      end
      context "with URI strings passed" do
        it "requests the correct resource" do
          @client.list_timeline("https://twitter.com/sferik", "https://twitter.com/sferik/presidents")
          expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_timeline("presidents")
        expect(a_get("/1.1/lists/statuses.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
    end
  end

  describe "#list_remove_member" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_member("sferik", "presidents", 813286)
        expect(a_post("/1.1/lists/members/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
      it "returns the list" do
        list = @client.list_remove_member("sferik", "presidents", 813286)
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/members/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_member("presidents", 813286)
        expect(a_post("/1.1/lists/members/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
  end

  describe "#memberships" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("memberships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.memberships("sferik")
        expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      it "returns the lists the specified user has been added to" do
        memberships = @client.memberships("sferik")
        expect(memberships).to be_a Twitter::Cursor
        expect(memberships.first).to be_a Twitter::List
        expect(memberships.first.name).to eq("developer")
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"}).to_return(:body => fixture("memberships2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.memberships("sferik").each{}
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/lists/memberships.json").with(:query => {:user_id => "7505382", :cursor => "-1"}).to_return(:body => fixture("memberships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.memberships(7505382)
        expect(a_get("/1.1/lists/memberships.json").with(:query => {:user_id => "7505382", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(:query => {:user_id => "7505382", :cursor => "1401037770457540712"}).to_return(:body => fixture("memberships2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.memberships(7505382).each{}
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:user_id => "7505382", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:user_id => "7505382", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("memberships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.memberships
        expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"}).to_return(:body => fixture("memberships2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.memberships.each{}
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/memberships.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
  end

  describe "#list_subscribers" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribers("sferik", "presidents")
        expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      it "returns the subscribers of the specified list" do
        list_subscribers = @client.list_subscribers("sferik", "presidents")
        expect(list_subscribers).to be_a Twitter::Cursor
        expect(list_subscribers.first).to be_a Twitter::User
        expect(list_subscribers.first.id).to eq(7505382)
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_subscribers("sferik", "presidents").each{}
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribers(7505382, "presidents")
        expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_subscribers(7505382, "presidents").each{}
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribers("presidents")
        expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_subscribers("presidents").each{}
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscribers.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
  end

  describe "#list_subscribe" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/subscribers/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribe("sferik", "presidents")
        expect(a_post("/1.1/lists/subscribers/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
      it "returns the specified list" do
        list = @client.list_subscribe("sferik", "presidents")
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/subscribers/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribe("presidents")
        expect(a_post("/1.1/lists/subscribers/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
    end
  end

  describe "#list_subscriber?" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "18755393"}).to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "12345678"}).to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 813286)
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
      it "returns true if the specified user subscribes to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 813286)
        expect(list_subscriber).to be_true
      end
      it "returns false if the specified user does not subscribe to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 18755393)
        expect(list_subscriber).to be_false
      end
      it "returns false if user does not exist" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 12345678)
        expect(list_subscriber).to be_false
      end
    end
    context "with a owner ID passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?(12345678, "presidents", 813286)
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678", :user_id => "813286"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("sferik", 12345678, 813286)
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a list object passed" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678", :user_id => "813286"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        list = Twitter::List.new(:id => 12345678, :user => {:id => 7505382, :screen_name => "sferik"})
        @client.list_subscriber?(list, 813286)
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a screen name passed for user_to_check" do
      before do
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :screen_name => "erebor"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", "erebor")
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :screen_name => "erebor"})).to have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("presidents", 813286)
        expect(a_get("/1.1/lists/subscribers/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
  end

  describe "#list_unsubscribe" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/subscribers/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_unsubscribe("sferik", "presidents")
        expect(a_post("/1.1/lists/subscribers/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
      it "returns the specified list" do
        list = @client.list_unsubscribe("sferik", "presidents")
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/subscribers/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_unsubscribe("presidents")
        expect(a_post("/1.1/lists/subscribers/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
    end
  end

  describe "#list_add_members" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members("sferik", "presidents", [813286, 18755393])
        expect(a_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"})).to have_been_made
      end
      it "returns the list" do
        list = @client.list_add_members("sferik", "presidents", [813286, 18755393])
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members("sferik", "presidents", [813286, "pengwynn", 18755393, "erebor"])
        expect(a_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"})).to have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members("presidents", [813286, 18755393])
        expect(a_post("/1.1/lists/members/create_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"})).to have_been_made
      end
    end
  end

  describe "#list_member?" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "65493023"}).to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "12345678"}).to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", 813286)
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
      it "returns true if user is a list member" do
        list_member = @client.list_member?("sferik", "presidents", 813286)
        expect(list_member).to be_true
      end
      it "returns false if user is not a list member" do
        list_member = @client.list_member?("sferik", "presidents", 65493023)
        expect(list_member).to be_false
      end
      it "returns false if user does not exist" do
        list_member = @client.list_member?("sferik", "presidents", 12345678)
        expect(list_member).to be_false
      end
    end
    context "with an owner ID passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?(12345678, "presidents", 813286)
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("sferik", 12345678, 813286)
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a list object passed" do
      before do
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        list = Twitter::List.new(:id => 12345678, :user => {:id => 7505382, :screen_name => "sferik"})
        @client.list_member?(list, 813286)
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678", :user_id => "813286"})).to have_been_made
      end
    end
    context "with a screen name passed for user_to_check" do
      before do
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :screen_name => "erebor"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", "erebor")
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :screen_name => "erebor"})).to have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("presidents", 813286)
        expect(a_get("/1.1/lists/members/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
  end

  describe "#list_members" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_members("sferik", "presidents")
        expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      it "returns the members of the specified list" do
        list_members = @client.list_members("sferik", "presidents")
        expect(list_members).to be_a Twitter::Cursor
        expect(list_members.first).to be_a Twitter::User
        expect(list_members.first.id).to eq(7505382)
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_members("sferik", "presidents").each{}
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/lists/members.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_members(7505382, "presidents")
        expect(a_get("/1.1/lists/members.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_members(7505382, "presidents").each{}
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_id => "7505382", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_members("presidents")
        expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"}).to_return(:body => fixture("users_list2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.list_members("presidents").each{}
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/members.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents", :cursor => "1322801608223717003"})).to have_been_made
        end
      end
    end
  end

  describe "#list_add_member" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_member("sferik", "presidents", 813286)
        expect(a_post("/1.1/lists/members/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
      it "returns the list" do
        list = @client.list_add_member("sferik", "presidents", 813286)
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/members/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_member("presidents", 813286)
        expect(a_post("/1.1/lists/members/create.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286"})).to have_been_made
      end
    end
  end

  describe "#list_destroy" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("sferik", "presidents")
        expect(a_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
      it "returns the deleted list" do
        list = @client.list_destroy("sferik", "presidents")
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("presidents")
        expect(a_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :list_id => "12345678"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("sferik", 12345678)
        expect(a_post("/1.1/lists/destroy.json").with(:body => {:owner_screen_name => "sferik", :list_id => "12345678"})).to have_been_made
      end
    end
    context "with a list object passed" do
      before do
        stub_post("/1.1/lists/destroy.json").with(:body => {:owner_id => "7505382", :list_id => "12345678"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        list = Twitter::List.new(:id => "12345678", :user => {:id => 7505382, :screen_name => "sferik"})
        @client.list_destroy(list)
        expect(a_post("/1.1/lists/destroy.json").with(:body => {:owner_id => "7505382", :list_id => "12345678"})).to have_been_made
      end
    end
  end

  describe "#list_update" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :description => "Presidents of the United States of America"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        expect(a_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :description => "Presidents of the United States of America"})).to have_been_made
      end
      it "returns the updated list" do
        list = @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :description => "Presidents of the United States of America"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("presidents", :description => "Presidents of the United States of America")
        expect(a_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :description => "Presidents of the United States of America"})).to have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :list_id => "12345678", :description => "Presidents of the United States of America"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("sferik", 12345678, :description => "Presidents of the United States of America")
        expect(a_post("/1.1/lists/update.json").with(:body => {:owner_screen_name => "sferik", :list_id => "12345678", :description => "Presidents of the United States of America"})).to have_been_made
      end
    end
    context "with a list object passed" do
      before do
        stub_post("/1.1/lists/update.json").with(:body => {:owner_id => "7505382", :list_id => "12345678", :description => "Presidents of the United States of America"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        list = Twitter::List.new(:id => "12345678", :user => {:id => 7505382, :screen_name => "sferik"})
        @client.list_update(list, :description => "Presidents of the United States of America")
        expect(a_post("/1.1/lists/update.json").with(:body => {:owner_id => "7505382", :list_id => "12345678", :description => "Presidents of the United States of America"})).to have_been_made
      end
    end
  end

  describe "#list_create" do
    before do
      stub_post("/1.1/lists/create.json").with(:body => {:name => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.list_create("presidents")
      expect(a_post("/1.1/lists/create.json").with(:body => {:name => "presidents"})).to have_been_made
    end
    it "returns the created list" do
      list = @client.list_create("presidents")
      expect(list).to be_a Twitter::List
      expect(list.name).to eq("presidents")
    end
  end

  describe "#list" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("sferik", "presidents")
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
      it "returns the updated list" do
        list = @client.list("sferik", "presidents")
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/lists/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list(12345678, "presidents")
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents"})).to have_been_made
      end
    end
    context "with a user object passed" do
      before do
        stub_get("/1.1/lists/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user = Twitter::User.new(:id => "12345678")
        @client.list(user, "presidents")
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_id => "12345678", :slug => "presidents"})).to have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("presidents")
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :slug => "presidents"})).to have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("sferik", 12345678)
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_screen_name => "sferik", :list_id => "12345678"})).to have_been_made
      end
    end
    context "with a list object passed" do
      before do
        stub_get("/1.1/lists/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        list = Twitter::List.new(:id => "12345678", :user => {:id => 7505382, :screen_name => "sferik"})
        @client.list(list)
        expect(a_get("/1.1/lists/show.json").with(:query => {:owner_id => "7505382", :list_id => "12345678"})).to have_been_made
      end
    end
  end

  describe "#subscriptions" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("subscriptions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.subscriptions("sferik")
        expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      it "returns the lists the specified user follows" do
        subscriptions = @client.subscriptions("sferik")
        expect(subscriptions).to be_a Twitter::Cursor
        expect(subscriptions.first).to be_a Twitter::List
        expect(subscriptions.first.name).to eq("Rubyists")
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"}).to_return(:body => fixture("subscriptions2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.subscriptions("sferik").each{}
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/lists/subscriptions.json").with(:query => {:user_id => "7505382", :cursor => "-1"}).to_return(:body => fixture("subscriptions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.subscriptions(7505382)
        expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:user_id => "7505382", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(:query => {:user_id => "7505382", :cursor => "1401037770457540712"}).to_return(:body => fixture("subscriptions2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.subscriptions(7505382).each{}
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:user_id => "7505382", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:user_id => "7505382", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("subscriptions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.subscriptions
        expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      context "with each" do
        before do
          stub_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"}).to_return(:body => fixture("subscriptions2.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.subscriptions.each{}
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
          expect(a_get("/1.1/lists/subscriptions.json").with(:query => {:screen_name => "sferik", :cursor => "1401037770457540712"})).to have_been_made
        end
      end
    end
  end

  describe "#list_remove_members" do
    context "with a screen name passed" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members("sferik", "presidents", [813286, 18755393])
        expect(a_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"})).to have_been_made
      end
      it "returns the list" do
        list = @client.list_remove_members("sferik", "presidents", [813286, 18755393])
        expect(list).to be_a Twitter::List
        expect(list.name).to eq("presidents")
      end
    end
    context "with a user ID passed" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_id => "7505382", :slug => "presidents", :user_id => "813286,18755393"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members(7505382, "presidents", [813286, 18755393])
        expect(a_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_id => "7505382", :slug => "presidents", :user_id => "813286,18755393"})).to have_been_made
      end
    end
    context "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members("sferik", "presidents", [813286, "pengwynn", 18755393, "erebor"])
        expect(a_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"})).to have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"}).to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members("presidents", [813286, 18755393])
        expect(a_post("/1.1/lists/members/destroy_all.json").with(:body => {:owner_screen_name => "sferik", :slug => "presidents", :user_id => "813286,18755393"})).to have_been_made
      end
    end
  end

  describe "#lists_owned" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/lists/ownerships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("ownerships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists_owned("sferik")
        expect(a_get("/1.1/lists/ownerships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      it "returns the requested list" do
        lists = @client.lists_owned("sferik")
        expect(lists).to be_a Twitter::Cursor
        expect(lists.first).to be_a Twitter::List
        expect(lists.first.name).to eq("My favstar.fm list")
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/lists/ownerships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"}).to_return(:body => fixture("ownerships.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists_owned
        expect(a_get("/1.1/lists/ownerships.json").with(:query => {:screen_name => "sferik", :cursor => "-1"})).to have_been_made
      end
      it "returns the requested list" do
        lists = @client.lists_owned
        expect(lists).to be_a Twitter::Cursor
        expect(lists.first).to be_a Twitter::List
        expect(lists.first.name).to eq("My favstar.fm list")
      end
    end
  end

end
