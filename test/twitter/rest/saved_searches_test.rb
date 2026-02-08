require "test_helper"

describe Twitter::REST::SavedSearches do
  before do
    @client = build_rest_client
  end

  describe "#saved_searches" do
    describe "with ids passed" do
      before do
        stub_get("/1.1/saved_searches/show/16129012.json").to_return(body: fixture("saved_search.json"), headers: json_headers)
        stub_get("/1.1/saved_searches/show/16129013.json").to_return(body: fixture("saved_search.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.saved_searches(16_129_012, 16_129_013)

        assert_requested(a_get("/1.1/saved_searches/show/16129012.json"))
        assert_requested(a_get("/1.1/saved_searches/show/16129013.json"))
      end

      it "returns an array of saved searches" do
        saved_searches = @client.saved_searches(16_129_012, 16_129_013)

        assert_kind_of(Array, saved_searches)
        assert_equal(2, saved_searches.size)
        assert_kind_of(Twitter::SavedSearch, saved_searches.first)
        assert_equal("twitter", saved_searches.first.name)
        assert_kind_of(Twitter::SavedSearch, saved_searches.last)
        assert_equal("twitter", saved_searches.last.name)
      end

      it "passes options to each saved_search request" do
        stub_get("/1.1/saved_searches/show/16129012.json").with(query: {include_entities: "true"}).to_return(body: fixture("saved_search.json"), headers: json_headers)
        stub_get("/1.1/saved_searches/show/16129013.json").with(query: {include_entities: "true"}).to_return(body: fixture("saved_search.json"), headers: json_headers)

        @client.saved_searches(16_129_012, 16_129_013, include_entities: true)

        assert_requested(a_get("/1.1/saved_searches/show/16129012.json").with(query: {include_entities: "true"}))
        assert_requested(a_get("/1.1/saved_searches/show/16129013.json").with(query: {include_entities: "true"}))
      end
    end

    describe "without ids passed" do
      before do
        stub_get("/1.1/saved_searches/list.json").to_return(body: fixture("saved_searches.json"), headers: json_headers)
      end

      it "requests the correct resource" do
        @client.saved_searches

        assert_requested(a_get("/1.1/saved_searches/list.json"))
      end

      it "returns the saved search queries for the authenticated user" do
        saved_searches = @client.saved_searches

        assert_kind_of(Array, saved_searches)
        assert_kind_of(Twitter::SavedSearch, saved_searches.first)
        assert_equal("twitter", saved_searches.first.name)
      end

      it "passes options to the list request" do
        stub_get("/1.1/saved_searches/list.json").with(query: {foo: "bar"}).to_return(body: fixture("saved_searches.json"), headers: json_headers)
        @client.saved_searches(foo: "bar")

        assert_requested(a_get("/1.1/saved_searches/list.json").with(query: {foo: "bar"}))
      end
    end
  end

  describe "#saved_search" do
    before do
      stub_get("/1.1/saved_searches/show/16129012.json").to_return(body: fixture("saved_search.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.saved_search(16_129_012)

      assert_requested(a_get("/1.1/saved_searches/show/16129012.json"))
    end

    it "returns a saved search" do
      saved_search = @client.saved_search(16_129_012)

      assert_kind_of(Twitter::SavedSearch, saved_search)
      assert_equal("twitter", saved_search.name)
    end

    it "passes options to the request" do
      stub_get("/1.1/saved_searches/show/16129012.json").with(query: {foo: "bar"}).to_return(body: fixture("saved_search.json"), headers: json_headers)
      @client.saved_search(16_129_012, foo: "bar")

      assert_requested(a_get("/1.1/saved_searches/show/16129012.json").with(query: {foo: "bar"}))
    end
  end

  describe "#create_saved_search" do
    before do
      stub_post("/1.1/saved_searches/create.json").with(body: {query: "twitter"}).to_return(body: fixture("saved_search.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.create_saved_search("twitter")

      assert_requested(a_post("/1.1/saved_searches/create.json").with(body: {query: "twitter"}))
    end

    it "returns the created saved search" do
      saved_search = @client.create_saved_search("twitter")

      assert_kind_of(Twitter::SavedSearch, saved_search)
      assert_equal("twitter", saved_search.name)
    end

    it "passes additional options in the request body" do
      stub_post("/1.1/saved_searches/create.json").with(body: {query: "twitter", foo: "bar"}).to_return(body: fixture("saved_search.json"), headers: json_headers)
      @client.create_saved_search("twitter", foo: "bar")

      assert_requested(a_post("/1.1/saved_searches/create.json").with(body: {query: "twitter", foo: "bar"}))
    end
  end

  describe "#destroy_saved_search" do
    before do
      stub_post("/1.1/saved_searches/destroy/16129012.json").to_return(body: fixture("saved_search.json"), headers: json_headers)
      stub_post("/1.1/saved_searches/destroy/16129013.json").to_return(body: fixture("saved_search.json"), headers: json_headers)
    end

    it "requests the correct resource" do
      @client.destroy_saved_search(16_129_012, 16_129_013)

      assert_requested(a_post("/1.1/saved_searches/destroy/16129012.json"))
      assert_requested(a_post("/1.1/saved_searches/destroy/16129013.json"))
    end

    it "returns an array of deleted saved searches" do
      saved_searches = @client.destroy_saved_search(16_129_012, 16_129_013)

      assert_kind_of(Array, saved_searches)
      assert_equal(2, saved_searches.size)
      assert_kind_of(Twitter::SavedSearch, saved_searches.first)
      assert_equal("twitter", saved_searches.first.name)
      assert_kind_of(Twitter::SavedSearch, saved_searches.last)
      assert_equal("twitter", saved_searches.last.name)
    end
  end
end
