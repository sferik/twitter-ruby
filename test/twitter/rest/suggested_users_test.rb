require "test_helper"

describe Twitter::REST::SuggestedUsers do
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

      it "passes options through to the category request" do
        stub_get("/1.1/users/suggestions/art-design.json").with(query: {lang: "en"}).to_return(body: fixture("category.json"), headers: json_headers)
        @client.suggestions("art-design", lang: "en")

        assert_requested(a_get("/1.1/users/suggestions/art-design.json").with(query: {lang: "en"}))
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

      it "passes options through to the list request" do
        stub_get("/1.1/users/suggestions.json").with(query: {lang: "en"}).to_return(body: fixture("suggestions.json"), headers: json_headers)
        @client.suggestions(lang: "en")

        assert_requested(a_get("/1.1/users/suggestions.json").with(query: {lang: "en"}))
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

    it "passes options through to the members request" do
      stub_get("/1.1/users/suggestions/art-design/members.json").with(query: {lang: "en"}).to_return(body: fixture("members.json"), headers: json_headers)
      @client.suggest_users("art-design", lang: "en")

      assert_requested(a_get("/1.1/users/suggestions/art-design/members.json").with(query: {lang: "en"}))
    end
  end
end
