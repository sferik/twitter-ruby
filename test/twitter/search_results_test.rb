require "test_helper"

describe Twitter::SearchResults do
  describe "#each" do
    before do
      @client = build_rest_client
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: json_headers)
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3", include_entities: "1", max_id: "414071361066532863"}).to_return(body: fixture("search2.json"), headers: json_headers)
    end

    it "requests the correct resources" do
      @client.search("#freebandnames").each {}

      assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}))
      assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3", include_entities: "1", max_id: "414071361066532863"}))
    end

    it "iterates" do
      count = 0
      search_results = @client.search("#freebandnames")
      search_results.each { count += 1 }

      assert_equal(6, count)
      assert_kind_of(Twitter::RateLimit, search_results.rate_limit)
    end

    it "returns Tweet objects" do
      search_results = @client.search("#freebandnames")
      tweets = search_results.to_a

      assert_kind_of(Twitter::Tweet, tweets.first)
      assert_kind_of(Integer, tweets.first.id)
    end

    it "passes through parameters to the next request" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "100"}).to_return(body: fixture("search.json"), headers: json_headers)
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "3", include_entities: "1", max_id: "414071361066532863"}).to_return(body: fixture("search2.json"), headers: json_headers)
      @client.search("#freebandnames", since_id: 414_071_360_078_878_542).each {}

      assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "100"}))
      assert_requested(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "3", include_entities: "1", max_id: "414071361066532863"}))
    end

    describe "with start" do
      it "iterates" do
        count = 0
        @client.search("#freebandnames").each(5) { count += 1 }

        assert_equal(1, count)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.search("#freebandnames").each(5)

        assert_kind_of(Enumerator, enum)
        assert_equal(1, enum.to_a.size)
      end
    end

    describe "without a block" do
      it "returns an Enumerator" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: json_headers)
        result = @client.search("#freebandnames").each

        assert_kind_of(Enumerator, result)
      end
    end

    describe "when search_metadata is nil" do
      it "handles missing metadata gracefully" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[]}', headers: json_headers)
        count = 0
        @client.search("#test").each { count += 1 }

        assert_equal(0, count)
      end
    end

    describe "when next_results is missing" do
      it "does not paginate" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[],"search_metadata":{}}', headers: json_headers)
        count = 0
        @client.search("#test").each { count += 1 }

        assert_equal(0, count)
      end
    end

    describe "when statuses key is missing" do
      it "handles missing statuses gracefully" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"search_metadata":{}}', headers: json_headers)
        count = 0
        @client.search("#test").each { count += 1 }

        assert_equal(0, count)
      end
    end
  end

  describe "#attrs" do
    before do
      @client = build_rest_client
    end

    it "returns the parsed response hash" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[{"id":1}],"search_metadata":{"max_id":1}}', headers: json_headers)
      results = @client.search("#test")

      assert_kind_of(Hash, results.attrs)
      assert_equal(1, results.attrs[:search_metadata][:max_id])
    end
  end

  describe "#next_page" do
    before do
      @client = build_rest_client
    end

    it "returns nil when there is no next page" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[],"search_metadata":{}}', headers: json_headers)
      results = @client.search("#test")

      assert_nil(results.send(:next_page))
    end

    it "parses next_results query string into a hash with symbol keys" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[{"id":1}],"search_metadata":{"next_results":"?max_id=123&q=%23test"}}', headers: json_headers)
      results = @client.search("#test")
      next_page = results.send(:next_page)

      assert_kind_of(Hash, next_page)
      assert_kind_of(Symbol, next_page.keys.first)
      assert_equal("123", next_page[:max_id])
      assert_equal("#test", next_page[:q])
    end
  end

  describe "pagination internals" do
    let(:results) { Twitter::SearchResults.allocate }

    it "returns a strict boolean from #next_page?" do
      results.instance_variable_set(:@attrs, {search_metadata: {next_results: nil}})

      assert_false(results.send(:next_page?))
    end

    it "returns true when search_metadata includes next_results" do
      results.instance_variable_set(:@attrs, {search_metadata: {next_results: "?max_id=123&q=%23test"}})

      assert_predicate(results, :next_page?)
    end

    it "uses the default false reached_limit? from Enumerable" do
      results.instance_variable_set(:@attrs, {})

      assert_false(results.send(:reached_limit?))
    end

    it "uses search_metadata defaults when the key is missing" do
      attrs = Hash.new { |_hash, _key| {next_results: "?max_id=123&q=%23test"} }
      results.instance_variable_set(:@attrs, attrs)

      assert_predicate(results, :next_page?)
      assert_equal({max_id: "123", q: "#test"}, results.send(:next_page))
    end

    it "uses next_results defaults from search_metadata hashes" do
      metadata = Hash.new { |_hash, _key| "?max_id=321&q=%23fallback" }
      results.instance_variable_set(:@attrs, {search_metadata: metadata})

      assert_predicate(results, :next_page?)
      assert_equal({max_id: "321", q: "#fallback"}, results.send(:next_page))
    end
  end
end
