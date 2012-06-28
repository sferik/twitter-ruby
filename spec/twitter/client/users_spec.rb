require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#users" do
    context "with screen names passed" do
      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("sferik", "pengwynn")
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik,pengwynn"}).
          should have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        users = @client.users("sferik", "pengwynn")
        users.should be_an Array
        users.first.should be_a Twitter::User
        users.first.name.should eq "Erik Michaels-Ober"
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("0", "311")
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "0,311"}).
          should have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users(7505382, 14100886)
        a_get("/1/users/lookup.json").
          with(:query => {:user_id => "7505382,14100886"}).
          should have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("sferik", 14100886)
        a_get("/1/users/lookup.json").
          with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
          should have_been_made
      end
    end
    context "with user objects passed" do
      context "with user IDs" do
        before do
          stub_get("/1/users/lookup.json").
            with(:query => {:user_id => "7505382,14100886"}).
            to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:id => '7505382')
          user2 = Twitter::User.new(:id => '14100886')
          @client.users(user1, user2)
          a_get("/1/users/lookup.json").
            with(:query => {:user_id => "7505382,14100886"}).
            should have_been_made
        end
      end
      context "with screen_names IDs" do
        before do
          stub_get("/1/users/lookup.json").
            with(:query => {:screen_name => "sferik,pengwynn"}).
            to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:screen_name => 'sferik')
          user2 = Twitter::User.new(:screen_name => 'pengwynn')
          @client.users(user1, user2)
          a_get("/1/users/lookup.json").
            with(:query => {:screen_name => "sferik,pengwynn"}).
            should have_been_made
        end
      end
      context "with both screen names and user IDs" do
        before do
          stub_get("/1/users/lookup.json").
            with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
            to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user1 = Twitter::User.new(:screen_name => 'sferik')
          user2 = Twitter::User.new(:id => '14100886')
          @client.users(user1, user2)
          a_get("/1/users/lookup.json").
            with(:query => {:screen_name => "sferik", :user_id => "14100886"}).
            should have_been_made
        end
      end
    end
  end

  describe "#user_search" do
    before do
      stub_get("/1/users/search.json").
        with(:query => {:q => "Erik Michaels-Ober"}).
        to_return(:body => fixture("user_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.user_search("Erik Michaels-Ober")
      a_get("/1/users/search.json").
        with(:query => {:q => "Erik Michaels-Ober"}).
        should have_been_made
    end
    it "returns an array of user search results" do
      user_search = @client.user_search("Erik Michaels-Ober")
      user_search.should be_an Array
      user_search.first.should be_a Twitter::User
      user_search.first.name.should eq "Erik Michaels-Ober"
    end
  end

  describe "#user" do
    context "with a screen name passed" do
      before do
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("sferik")
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns extended information of a given user" do
        user = @client.user("sferik")
        user.should be_a Twitter::User
        user.name.should eq "Erik Michaels-Ober"
      end
    end
    context "with a screen name including '@' passed" do
      before do
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "@sferik"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("@sferik")
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "@sferik"}).
          should have_been_made
      end
    end
    context "with a numeric screen name passed" do
      before do
        stub_get("/1/users/show.json").
          with(:query => {:screen_name => "0"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("0")
        a_get("/1/users/show.json").
          with(:query => {:screen_name => "0"}).
          should have_been_made
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1/users/show.json").
          with(:query => {:user_id => "7505382"}).
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user(7505382)
        a_get("/1/users/show.json").
          with(:query => {:user_id => "7505382"}).
          should have_been_made
      end
    end
    context "with a user object passed" do
      context "with a user ID" do
        before do
          stub_get("/1/users/show.json").
            with(:query => {:user_id => "7505382"}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user = Twitter::User.new(:id => 7505382)
          @client.user(user)
          a_get("/1/users/show.json").
            with(:query => {:user_id => "7505382"}).
            should have_been_made
        end
      end
      context "with a screen_name" do
        before do
          stub_get("/1/users/show.json").
            with(:query => {:screen_name => "sferik"}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          user = Twitter::User.new(:screen_name => 'sferik')
          @client.user(user)
          a_get("/1/users/show.json").
            with(:query => {:screen_name => "sferik"}).
            should have_been_made
        end
      end
    end
    context "without a screen name or user ID passed" do
      context "without options passed" do
        before do
          stub_get("/1/account/verify_credentials.json").
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.user
          a_get("/1/account/verify_credentials.json").
            should have_been_made
        end
      end
      context "with options passed" do
        before do
          stub_get("/1/account/verify_credentials.json").
            with(:query => {:skip_status => "true"}).
            to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end
        it "requests the correct resource" do
          @client.user(:skip_status => true)
          a_get("/1/account/verify_credentials.json").
            with(:query => {:skip_status => "true"}).
            should have_been_made
        end
      end
    end
  end

  describe "#user?" do
    before do
      stub_get("/1/users/show.json").
        with(:query => {:screen_name => "sferik"}).
        to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1/users/show.json").
        with(:query => {:screen_name => "pengwynn"}).
        to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.user?("sferik")
      a_get("/1/users/show.json").
        with(:query => {:screen_name => "sferik"}).
        should have_been_made
    end
    it "returns true if user exists" do
      user = @client.user?("sferik")
      user.should be_true
    end
    it "returns false if user does not exist" do
      user = @client.user?("pengwynn")
      user.should be_false
    end
  end

  describe "#contributees" do
    context "with a screen name passed" do
      before do
        stub_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributees("sferik")
        a_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns a user's contributees" do
        contributees = @client.contributees("sferik")
        contributees.should be_an Array
        contributees.first.should be_a Twitter::User
        contributees.first.name.should eq "Twitter API"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributees
        a_get("/1/users/contributees.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns a user's contributees" do
        contributees = @client.contributees
        contributees.should be_an Array
        contributees.first.should be_a Twitter::User
        contributees.first.name.should eq "Twitter API"
      end
    end
  end

  describe "#contributors" do
    context "with a screen name passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributors("sferik")
        a_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns a user's contributors" do
        contributors = @client.contributors("sferik")
        contributors.should be_an Array
        contributors.first.should be_a Twitter::User
        contributors.first.name.should eq "Biz Stone"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributors
        a_get("/1/users/contributors.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns a user's contributors" do
        contributors = @client.contributors
        contributors.should be_an Array
        contributors.first.should be_a Twitter::User
        contributors.first.name.should eq "Biz Stone"
      end
    end
  end

  describe "#recommendations" do
    context "with a screen name passed" do
      before do
        stub_get("/1/users/recommendations.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("recommendations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.recommendations("sferik")
        a_get("/1/users/recommendations.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns recommended users for the authenticated user" do
        recommendations = @client.recommendations("sferik")
        recommendations.should be_an Array
        recommendations.first.should be_a Twitter::User
        recommendations.first.name.should eq "John Trupiano"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1/users/recommendations.json").
          with(:query => {:screen_name => "sferik"}).
          to_return(:body => fixture("recommendations.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.recommendations
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/1/users/recommendations.json").
          with(:query => {:screen_name => "sferik"}).
          should have_been_made
      end
      it "returns recommended users for the authenticated user" do
        recommendations = @client.recommendations
        recommendations.should be_an Array
        recommendations.first.should be_a Twitter::User
        recommendations.first.name.should eq "John Trupiano"
      end
    end
  end

  describe "#following_followers_of" do
    context "with a screen_name passed" do
      before do
        stub_get("/users/following_followers_of.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of("sferik")
        a_get("/users/following_followers_of.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of("sferik")
        following_followers_of.should be_a Twitter::Cursor
        following_followers_of.users.should be_an Array
        following_followers_of.users.first.should be_a Twitter::User
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/account/verify_credentials.json").
          to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/users/following_followers_of.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of
        a_get("/1/account/verify_credentials.json").
          should have_been_made
        a_get("/users/following_followers_of.json").
          with(:query => {:cursor => "-1", :screen_name => "sferik"}).
          should have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of
        following_followers_of.should be_a Twitter::Cursor
        following_followers_of.users.should be_an Array
        following_followers_of.users.first.should be_a Twitter::User
      end
    end
  end

end
