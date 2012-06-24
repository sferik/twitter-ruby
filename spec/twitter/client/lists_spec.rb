require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#lists_subscribed_to" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/all.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("all.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists_subscribed_to("sferik")
        a_get("/1/lists/all.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns the lists the specified user subscribes to" do
        lists = @client.lists_subscribed_to("sferik")
        lists.should be_an Array
        lists.first.should be_a Twitter::List
        lists.first.name.should eq "Rubyists"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/all.json").
          to_return(:body => fixture("all.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists_subscribed_to
        a_get("/1/lists/all.json").
          should have_been_made
      end
    end
  end

  describe "#list_timeline" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_timeline("sferik", "presidents")
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
      it "returns the timeline for members of the specified list" do
        statuses = @client.list_timeline("sferik", "presidents")
        statuses.should be_an Array
        statuses.first.should be_a Twitter::Status
        statuses.first.text.should eq "Ruby is the best programming language for hiding the ugly bits."
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("statuses.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_timeline("presidents")
        a_get("/1/lists/statuses.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
    end
  end

  describe "#list_remove_member" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_member("sferik", "presidents", 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end
      it "returns the list" do
        list = @client.list_remove_member("sferik", "presidents", 813286)
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_member("presidents", 813286)
        a_post("/1/lists/members/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end
    end
  end

  describe "#memberships" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.memberships("pengwynn")
        a_get("/1/lists/memberships.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end
      it "returns the lists the specified user has been added to" do
        memberships = @client.memberships("pengwynn")
        memberships.should be_a Twitter::Cursor
        memberships.lists.should be_an Array
        memberships.lists.first.should be_a Twitter::List
        memberships.lists.first.name.should eq "Rubyists"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/memberships.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.memberships
        a_get("/1/lists/memberships.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
    end
  end

  describe "#list_subscribers" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribers("sferik", "presidents")
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end
      it "returns the subscribers of the specified list" do
        list_subscribers = @client.list_subscribers("sferik", "presidents")
        list_subscribers.should be_a Twitter::Cursor
        list_subscribers.users.should be_an Array
        list_subscribers.users.first.should be_a Twitter::User
        list_subscribers.users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribers("presidents")
        a_get("/1/lists/subscribers.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end
    end
  end

  describe "#subscriptions" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.subscriptions("pengwynn")
        a_get("/1/lists/subscriptions.json").
          with(:query => {:screen_name => 'pengwynn', :cursor => "-1"}).
          should have_been_made
      end
      it "returns the lists the specified user follows" do
        subscriptions = @client.subscriptions("pengwynn")
        subscriptions.should be_a Twitter::Cursor
        subscriptions.lists.should be_an Array
        subscriptions.lists.first.should be_a Twitter::List
        subscriptions.lists.first.name.should eq "Rubyists"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscriptions.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.subscriptions
        a_get("/1/lists/subscriptions.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
    end
  end

  describe "#list_subscribe" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribe("sferik", "presidents")
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
      it "returns the specified list" do
        list = @client.list_subscribe("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscribe("presidents")
        a_post("/1/lists/subscribers/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
    end
  end

  describe "#list_subscriber?" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '18755393'}).
          to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '12345678'}).
          to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
      it "returns true if the specified user subscribes to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 813286)
        list_subscriber.should be_true
      end
      it "returns false if the specified user does not subscribe to the specified list" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 18755393)
        list_subscriber.should be_false
      end
      it "returns false if user does not exist" do
        list_subscriber = @client.list_subscriber?("sferik", "presidents", 12345678)
        list_subscriber.should be_false
      end
    end
    context "with a owner ID passed" do
      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?(12345678, "presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?('sferik', 12345678, 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          should have_been_made
      end
    end
    context "with a list object passed" do
      context "with a slug" do
        before do
          stub_get("/1/lists/subscribers/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:slug => 'presidents', :user => {:screen_name => 'sferik'})
          @client.list_subscriber?(list, 813286)
          a_get("/1/lists/subscribers/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
            should have_been_made
        end
      end
      context "with a list ID" do
        before do
          stub_get("/1/lists/subscribers/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:id => 12345678, :user => {:screen_name => 'sferik'})
          @client.list_subscriber?(list, 813286)
          a_get("/1/lists/subscribers/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
            should have_been_made
        end
      end
    end
    context "with a screen name passed for user_to_check" do
      before do
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("sferik", "presidents", 'erebor')
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          should have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_subscriber?("presidents", 813286)
        a_get("/1/lists/subscribers/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
  end

  describe "#list_unsubscribe" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_unsubscribe("sferik", "presidents")
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
      it "returns the specified list" do
        list = @client.list_unsubscribe("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_unsubscribe("presidents")
        a_post("/1/lists/subscribers/destroy.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
    end
  end

  describe "#list_add_members" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members("sferik", "presidents", [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end
      it "returns the list" do
        list = @client.list_add_members("sferik", "presidents", [813286, 18755393])
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members('sferik', 'presidents', [813286, 'pengwynn', 18755393, 'erebor'])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          should have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_members("presidents", [813286, 18755393])
        a_post("/1/lists/members/create_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end
    end
  end

  describe "#list_remove_members" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members("sferik", "presidents", [813286, 18755393])
        a_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end
      it "returns the list" do
        list = @client.list_remove_members("sferik", "presidents", [813286, 18755393])
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "with a combination of member IDs and member screen names to add" do
      before do
        stub_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members('sferik', 'presidents', [813286, 'pengwynn', 18755393, 'erebor'])
        a_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393", :screen_name => "pengwynn,erebor"}).
          should have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_remove_members("presidents", [813286, 18755393])
        a_post("/1/lists/members/destroy_all.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286,18755393"}).
          should have_been_made
      end
    end
  end

  describe "#list_member?" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '65493023'}).
          to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '12345678'}).
          to_return(:body => fixture("not_found.json"), :status => 403, :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
      it "returns true if user is a list member" do
        list_member = @client.list_member?("sferik", "presidents", 813286)
        list_member.should be_true
      end
      it "returns false if user is not a list member" do
        list_member = @client.list_member?("sferik", "presidents", 65493023)
        list_member.should be_false
      end
      it "returns false if user does not exist" do
        list_member = @client.list_member?("sferik", "presidents", 12345678)
        list_member.should be_false
      end
    end
    context "with an owner ID passed" do
      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?(12345678, "presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?('sferik', 12345678, 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
          should have_been_made
      end
    end
    context "with a list object passed" do
      context "with a slug" do
        before do
          stub_get("/1/lists/members/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:slug => 'presidents', :user => {:screen_name => 'sferik'})
          @client.list_member?(list, 813286)
          a_get("/1/lists/members/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
            should have_been_made
        end
      end
      context "with a list ID" do
        before do
          stub_get("/1/lists/members/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:id => 12345678, :user => {:screen_name => 'sferik'})
          @client.list_member?(list, 813286)
          a_get("/1/lists/members/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678', :user_id => '813286'}).
            should have_been_made
        end
      end
    end
    context "with a screen name passed for user_to_check" do
      before do
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("sferik", "presidents", 'erebor')
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :screen_name => 'erebor'}).
          should have_been_made
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/.json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_member?("presidents", 813286)
        a_get("/1/lists/members/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => '813286'}).
          should have_been_made
      end
    end
  end

  describe "#list_members" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_members("sferik", "presidents")
        a_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end
      it "returns the members of the specified list" do
        list_members = @client.list_members("sferik", "presidents")
        list_members.should be_a Twitter::Cursor
        list_members.users.should be_an Array
        list_members.users.first.should be_a Twitter::User
        list_members.users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_members("presidents")
        a_get("/1/lists/members.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents', :cursor => "-1"}).
          should have_been_made
      end
    end
  end

  describe "#list_add_member" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_member("sferik", "presidents", 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end
      it "returns the list" do
        list = @client.list_add_member("sferik", "presidents", 813286)
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_add_member("presidents", 813286)
        a_post("/1/lists/members/create.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :user_id => "813286"}).
          should have_been_made
      end
    end
  end

  describe "#list_destroy" do
    context "with a screen name passed" do
      before do
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("sferik", "presidents")
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
      it "returns the deleted list" do
        list = @client.list_destroy("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("presidents")
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_destroy("sferik", 12345678)
        a_delete("/1/lists/destroy.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end
    end
    context "with a list object passed" do
      context "with a slug" do
        before do
          stub_delete("/1/lists/destroy.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:slug => 'presidents', :user => {:screen_name => 'sferik'})
          @client.list_destroy(list)
          a_delete("/1/lists/destroy.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            should have_been_made
        end
      end
      context "with a list ID" do
        before do
          stub_delete("/1/lists/destroy.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:id => '12345678', :user => {:screen_name => 'sferik'})
          @client.list_destroy(list)
          a_delete("/1/lists/destroy.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
            should have_been_made
        end
      end
    end
  end

  describe "#list_update" do
    context "with a screen name passed" do
      before do
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
          should have_been_made
      end
      it "returns the updated list" do
        list = @client.list_update("sferik", "presidents", :description => "Presidents of the United States of America")
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("presidents", :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :slug => 'presidents', :description => "Presidents of the United States of America"}).
          should have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list_update("sferik", 12345678, :description => "Presidents of the United States of America")
        a_post("/1/lists/update.json").
          with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
          should have_been_made
      end
    end
    context "with a list object passed" do
      context "with a slug" do
        before do
          stub_post("/1/lists/update.json").
            with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:slug => 'presidents', :user => {:screen_name => 'sferik'})
          @client.list_update(list, :description => "Presidents of the United States of America")
          a_post("/1/lists/update.json").
            with(:body => {:owner_screen_name => 'sferik', :slug => "presidents", :description => "Presidents of the United States of America"}).
            should have_been_made
        end
      end
      context "with a list ID" do
        before do
          stub_post("/1/lists/update.json").
            with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:id => '12345678', :user => {:screen_name => 'sferik'})
          @client.list_update(list, :description => "Presidents of the United States of America")
          a_post("/1/lists/update.json").
            with(:body => {:owner_screen_name => 'sferik', :list_id => '12345678', :description => "Presidents of the United States of America"}).
            should have_been_made
        end
      end
    end
  end

  describe "#list_create" do
    before do
      stub_post("/1/lists/create.json").
        with(:body => {:name => "presidents"}).
        to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.list_create("presidents")
      a_post("/1/lists/create.json").
        with(:body => {:name => "presidents"}).
        should have_been_made
    end
    it "returns the created list" do
      list = @client.list_create("presidents")
      list.should be_a Twitter::List
      list.name.should eq "presidents"
    end
  end

  describe "#lists" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists.json").
          with(:query => {:screen_name => 'sferik', :cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists("sferik")
        a_get("/1/lists.json").
          with(:query => {:screen_name => 'sferik', :cursor => "-1"}).
          should have_been_made
      end
      it "returns the requested lists" do
        lists = @client.lists("sferik")
        lists.should be_a Twitter::Cursor
        lists.lists.should be_an Array
        lists.lists.first.should be_a Twitter::List
        lists.lists.first.name.should eq "Rubyists"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/lists.json").
          with(:query => {:cursor => "-1"}).
          to_return(:body => fixture("lists.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.lists
        a_get("/1/lists.json").
          with(:query => {:cursor => "-1"}).
          should have_been_made
      end
      it "returns the requested list" do
        lists = @client.lists
        lists.should be_a Twitter::Cursor
        lists.lists.should be_an Array
        lists.lists.first.should be_a Twitter::List
        lists.lists.first.name.should eq "Rubyists"
      end
    end
  end

  describe "#list" do
    context "with a screen name passed" do
      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("sferik", "presidents")
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
      it "returns the updated list" do
        list = @client.list("sferik", "presidents")
        list.should be_a Twitter::List
        list.name.should eq "presidents"
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list(12345678, 'presidents')
        a_get("/1/lists/show.json").
          with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
          should have_been_made
      end
    end
    context "with a user object passed" do
      context "with a user ID" do
        before do
          stub_get("/1/lists/show.json").
            with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user = Twitter::User.new(:id => '12345678')
          @client.list(user, 'presidents')
          a_get("/1/lists/show.json").
            with(:query => {:owner_id => '12345678', :slug => 'presidents'}).
            should have_been_made
        end
      end
      context "with a screen name" do
        before do
          stub_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user = Twitter::User.new(:screen_name => 'sferik')
          @client.list(user, "presidents")
          a_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            should have_been_made
        end
      end
    end
    context "without a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("presidents")
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
          should have_been_made
      end
    end
    context "with a list ID passed" do
      before do
        stub_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.list("sferik", 12345678)
        a_get("/1/lists/show.json").
          with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
          should have_been_made
      end
    end
    context "with a list object passed" do
      context "with a slug" do
        before do
          stub_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:slug => 'presidents', :user => {:screen_name => 'sferik'})
          @client.list(list)
          a_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :slug => 'presidents'}).
            should have_been_made
        end
      end
      context "with a list ID" do
        before do
          stub_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
            to_return(:body => fixture("list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          list = Twitter::List.new(:id => '12345678', :user => {:screen_name => 'sferik'})
          @client.list(list)
          a_get("/1/lists/show.json").
            with(:query => {:owner_screen_name => 'sferik', :list_id => '12345678'}).
            should have_been_made
        end
      end
    end
  end

end
