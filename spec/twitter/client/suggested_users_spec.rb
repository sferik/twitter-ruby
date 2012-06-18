require 'helper'

describe Twitter::Client do

  before do
    @client = Twitter::Client.new
  end

  describe "#suggestions" do
    context "with a category slug passed" do
      before do
        stub_get("/1/users/suggestions/art-design.json").
          to_return(:body => fixture("category.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.suggestions("art-design")
        a_get("/1/users/suggestions/art-design.json").
          should have_been_made
      end
      it "returns the users in a given category of the Twitter suggested user list" do
        suggestion = @client.suggestions("art-design")
        suggestion.should be_a Twitter::Suggestion
        suggestion.name.should eq "Art & Design"
        suggestion.users.should be_an Array
        suggestion.users.first.should be_a Twitter::User
      end
    end
    context "without arguments passed" do
      before do
        stub_get("/1/users/suggestions.json").
          to_return(:body => fixture("suggestions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
      end
      it "requests the correct resource" do
        @client.suggestions
        a_get("/1/users/suggestions.json").
          should have_been_made
      end
      it "returns the list of suggested user categories" do
        suggestions = @client.suggestions
        suggestions.should be_an Array
        suggestions.first.should be_a Twitter::Suggestion
        suggestions.first.name.should eq "Art & Design"
      end
    end
  end

  describe "#suggest_users" do
    before do
      stub_get("/1/users/suggestions/art-design/members.json").
        to_return(:body => fixture("members.json"), :headers => {:content_type => "application/json; charset=utf-8"})
    end
    it "requests the correct resource" do
      @client.suggest_users("art-design")
      a_get("/1/users/suggestions/art-design/members.json").
        should have_been_made
    end
    it "returns users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user" do
      suggest_users = @client.suggest_users("art-design")
      suggest_users.should be_an Array
      suggest_users.first.should be_a Twitter::User
      suggest_users.first.name.should eq "OMGFacts"
    end
  end

end
