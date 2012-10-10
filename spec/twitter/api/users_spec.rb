require 'helper'

describe Twitter::API do

  before do
    @client = Twitter::Client.new
  end

  describe "#suggestions" do
    context "with a category slug passed" do
      before do
        stub_get("/1.1/users/suggestions/art-design.json").to_return(:body => fixture("category.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.suggestions("art-design")
        expect(a_get("/1.1/users/suggestions/art-design.json")).to have_been_made
      end
      it "returns the users in a given category of the Twitter suggested user list" do
        suggestion = @client.suggestions("art-design")
        expect(suggestion).to be_a Twitter::Suggestion
        expect(suggestion.name).to eq "Art & Design"
        expect(suggestion.users).to be_an Array
        expect(suggestion.users.first).to be_a Twitter::User
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/users/suggestions.json").to_return(:body => fixture("suggestions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.suggestions
        expect(a_get("/1.1/users/suggestions.json")).to have_been_made
      end
      it "returns the list of suggested user categories" do
        suggestions = @client.suggestions
        expect(suggestions).to be_an Array
        expect(suggestions.first).to be_a Twitter::Suggestion
        expect(suggestions.first.name).to eq "Art & Design"
      end
    end
  end

  describe "#suggest_users" do
    before do
      stub_get("/1.1/users/suggestions/art-design/members.json").to_return(:body => fixture("members.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.suggest_users("art-design")
      expect(a_get("/1.1/users/suggestions/art-design/members.json")).to have_been_made
    end
    it "returns users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user" do
      suggest_users = @client.suggest_users("art-design")
      expect(suggest_users).to be_an Array
      expect(suggest_users.first).to be_a Twitter::User
      expect(suggest_users.first.name).to eq "OMGFacts"
    end
  end

  describe "#users" do
    context "with screen names passed" do
      before do
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"}).to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("sferik", "pengwynn")
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik,pengwynn"})).to have_been_made
      end
      it "returns up to 100 users worth of extended information" do
        users = @client.users("sferik", "pengwynn")
        expect(users).to be_an Array
        expect(users.first).to be_a Twitter::User
        expect(users.first.id).to eq 7505382
      end
    end
    context "with numeric screen names passed" do
      before do
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "0,311"}).to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("0", "311")
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "0,311"})).to have_been_made
      end
    end
    context "with user IDs passed" do
      before do
        stub_post("/1.1/users/lookup.json").with(:body => {:user_id => "7505382,14100886"}).to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users(7505382, 14100886)
        expect(a_post("/1.1/users/lookup.json").with(:body => {:user_id => "7505382,14100886"})).to have_been_made
      end
    end
    context "with both screen names and user IDs passed" do
      before do
        stub_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik", :user_id => "14100886"}).to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.users("sferik", 14100886)
        expect(a_post("/1.1/users/lookup.json").with(:body => {:screen_name => "sferik", :user_id => "14100886"})).to have_been_made
      end
    end
    context "with user objects passed" do
      before do
        stub_post("/1.1/users/lookup.json").with(:body => {:user_id => "7505382,14100886"}).to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user1 = Twitter::User.new(:id => '7505382')
        user2 = Twitter::User.new(:id => '14100886')
        @client.users(user1, user2)
        expect(a_post("/1.1/users/lookup.json").with(:body => {:user_id => "7505382,14100886"})).to have_been_made
      end
    end
  end

  describe "#user_search" do
    before do
      stub_get("/1.1/users/search.json").with(:query => {:q => "Erik Michaels-Ober"}).to_return(:body => fixture("user_search.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.user_search("Erik Michaels-Ober")
      expect(a_get("/1.1/users/search.json").with(:query => {:q => "Erik Michaels-Ober"})).to have_been_made
    end
    it "returns an array of user search results" do
      user_search = @client.user_search("Erik Michaels-Ober")
      expect(user_search).to be_an Array
      expect(user_search.first).to be_a Twitter::User
      expect(user_search.first.id).to eq 7505382
    end
  end

  describe "#user" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("sferik")
        expect(a_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns extended information of a given user" do
        user = @client.user("sferik")
        expect(user).to be_a Twitter::User
        expect(user.id).to eq 7505382
      end
    end
    context "with a screen name including '@' passed" do
      before do
        stub_get("/1.1/users/show.json").with(:query => {:screen_name => "@sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("@sferik")
        expect(a_get("/1.1/users/show.json").with(:query => {:screen_name => "@sferik"})).to have_been_made
      end
    end
    context "with a numeric screen name passed" do
      before do
        stub_get("/1.1/users/show.json").with(:query => {:screen_name => "0"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user("0")
        expect(a_get("/1.1/users/show.json").with(:query => {:screen_name => "0"})).to have_been_made
      end
    end
    context "with a user ID passed" do
      before do
        stub_get("/1.1/users/show.json").with(:query => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user(7505382)
        expect(a_get("/1.1/users/show.json").with(:query => {:user_id => "7505382"})).to have_been_made
      end
    end
    context "with a user object passed" do
      before do
        stub_get("/1.1/users/show.json").with(:query => {:user_id => "7505382"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        user = Twitter::User.new(:id => 7505382)
        @client.user(user)
        expect(a_get("/1.1/users/show.json").with(:query => {:user_id => "7505382"})).to have_been_made
      end
    end
  end
  context "without a screen name or user ID passed" do
    context "without options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
      end
    end
    context "with options passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").with(:query => {:skip_status => "true"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.user(:skip_status => true)
        expect(a_get("/1.1/account/verify_credentials.json").with(:query => {:skip_status => "true"})).to have_been_made
      end
    end
  end

  describe "#user?" do
    before do
      stub_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      stub_get("/1.1/users/show.json").with(:query => {:screen_name => "pengwynn"}).to_return(:body => fixture("not_found.json"), :status => 404, :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.user?("sferik")
      expect(a_get("/1.1/users/show.json").with(:query => {:screen_name => "sferik"})).to have_been_made
    end
    it "returns true if user exists" do
      user = @client.user?("sferik")
      expect(user).to be_true
    end
    it "returns false if user does not exist" do
      user = @client.user?("pengwynn")
      expect(user).to be_false
    end
  end

  describe "#contributees" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/users/contributees.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributees("sferik")
        expect(a_get("/1.1/users/contributees.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns a user's contributees" do
        contributees = @client.contributees("sferik")
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq "Twitter API"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/contributees.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("contributees.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributees
        expect(a_get("/1.1/users/contributees.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns a user's contributees" do
        contributees = @client.contributees
        expect(contributees).to be_an Array
        expect(contributees.first).to be_a Twitter::User
        expect(contributees.first.name).to eq "Twitter API"
      end
    end
  end

  describe "#contributors" do
    context "with a screen name passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/contributors.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributors("sferik")
        expect(a_get("/1.1/users/contributors.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns a user's contributors" do
        contributors = @client.contributors("sferik")
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.name).to eq "Biz Stone"
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/1.1/users/contributors.json").with(:query => {:screen_name => "sferik"}).to_return(:body => fixture("contributors.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.contributors
        expect(a_get("/1.1/users/contributors.json").with(:query => {:screen_name => "sferik"})).to have_been_made
      end
      it "returns a user's contributors" do
        contributors = @client.contributors
        expect(contributors).to be_an Array
        expect(contributors.first).to be_a Twitter::User
        expect(contributors.first.name).to eq "Biz Stone"
      end
    end
  end

  describe "#following_followers_of" do
    context "with a screen_name passed" do
      before do
        stub_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of("sferik")
        expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of("sferik")
        expect(following_followers_of).to be_a Twitter::Cursor
        expect(following_followers_of.users).to be_an Array
        expect(following_followers_of.users.first).to be_a Twitter::User
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1.1/account/verify_credentials.json").to_return(:body => fixture("sferik.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        stub_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"}).to_return(:body => fixture("users_list.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.following_followers_of
        expect(a_get("/1.1/account/verify_credentials.json")).to have_been_made
        expect(a_get("/users/following_followers_of.json").with(:query => {:cursor => "-1", :screen_name => "sferik"})).to have_been_made
      end
      it "returns an array of numeric IDs for every user following the specified user" do
        following_followers_of = @client.following_followers_of
        expect(following_followers_of).to be_a Twitter::Cursor
        expect(following_followers_of.users).to be_an Array
        expect(following_followers_of.users.first).to be_a Twitter::User
      end
    end
  end

end
