require 'helper'

describe Twitter::REST::API::SuggestedUsers do

  before do
    @client = Twitter::REST::Client.new(:consumer_key => "CK", :consumer_secret => "CS", :access_token => "AT", :access_token_secret => "AS")
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
        expect(suggestion.name).to eq("Art & Design")
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
        expect(suggestions.first.name).to eq("Art & Design")
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
      expect(suggest_users.first.id).to eq(13)
    end
  end

end
