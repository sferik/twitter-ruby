require "helper"

describe Twitter::SearchResults do
  describe "#each" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3", include_entities: "1", max_id: "414071361066532863"}).to_return(body: fixture("search2.json"), headers: {content_type: "application/json; charset=utf-8"})
    end

    it "requests the correct resources" do
      @client.search("#freebandnames").each {}
      expect(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"})).to have_been_made
      expect(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "3", include_entities: "1", max_id: "414071361066532863"})).to have_been_made
    end

    it "iterates" do
      count = 0
      search_results = @client.search("#freebandnames")
      search_results.each { count += 1 }
      expect(count).to eq(6)
      expect(search_results.rate_limit).to be_a(Twitter::RateLimit)
    end

    it "returns Tweet objects" do
      search_results = @client.search("#freebandnames")
      tweets = search_results.to_a
      expect(tweets.first).to be_a(Twitter::Tweet)
      expect(tweets.first.id).to be_an(Integer)
    end

    it "passes through parameters to the next request" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "100"}).to_return(body: fixture("search.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "3", include_entities: "1", max_id: "414071361066532863"}).to_return(body: fixture("search2.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.search("#freebandnames", since_id: 414_071_360_078_878_542).each {}
      expect(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "100"})).to have_been_made
      expect(a_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", since_id: "414071360078878542", count: "3", include_entities: "1", max_id: "414071361066532863"})).to have_been_made
    end

    context "with start" do
      it "iterates" do
        count = 0
        @client.search("#freebandnames").each(5) { count += 1 }
        expect(count).to eq(1)
      end

      it "returns an enumerator that honors the start argument" do
        enum = @client.search("#freebandnames").each(5)
        expect(enum).to be_an(Enumerator)
        expect(enum.to_a.size).to eq(1)
      end
    end

    context "without a block" do
      it "returns an Enumerator" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#freebandnames", count: "100"}).to_return(body: fixture("search.json"), headers: {content_type: "application/json; charset=utf-8"})
        result = @client.search("#freebandnames").each
        expect(result).to be_an Enumerator
      end
    end

    context "when search_metadata is nil" do
      it "handles missing metadata gracefully" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[]}', headers: {content_type: "application/json; charset=utf-8"})
        count = 0
        @client.search("#test").each { count += 1 }
        expect(count).to eq(0)
      end
    end

    context "when next_results is missing" do
      it "does not paginate" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[],"search_metadata":{}}', headers: {content_type: "application/json; charset=utf-8"})
        count = 0
        @client.search("#test").each { count += 1 }
        expect(count).to eq(0)
      end
    end

    context "when statuses key is missing" do
      it "handles missing statuses gracefully" do
        stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"search_metadata":{}}', headers: {content_type: "application/json; charset=utf-8"})
        count = 0
        @client.search("#test").each { count += 1 }
        expect(count).to eq(0)
      end
    end
  end

  describe "#attrs" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    end

    it "returns the parsed response hash" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[{"id":1}],"search_metadata":{"max_id":1}}', headers: {content_type: "application/json; charset=utf-8"})
      results = @client.search("#test")
      expect(results.attrs).to be_a(Hash)
      expect(results.attrs[:search_metadata][:max_id]).to eq(1)
    end
  end

  describe "#next_page" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS")
    end

    it "returns nil when there is no next page" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[],"search_metadata":{}}', headers: {content_type: "application/json; charset=utf-8"})
      results = @client.search("#test")
      expect(results.send(:next_page)).to be_nil
    end

    it "parses next_results query string into a hash with symbol keys" do
      stub_get("/1.1/search/tweets.json").with(query: {q: "#test", count: "100"}).to_return(body: '{"statuses":[{"id":1}],"search_metadata":{"next_results":"?max_id=123&q=%23test"}}', headers: {content_type: "application/json; charset=utf-8"})
      results = @client.search("#test")
      next_page = results.send(:next_page)
      expect(next_page).to be_a(Hash)
      expect(next_page.keys.first).to be_a(Symbol)
      expect(next_page[:max_id]).to eq("123")
      expect(next_page[:q]).to eq("#test")
    end
  end

  describe "pagination internals" do
    let(:results) { described_class.allocate }

    it "returns a strict boolean from #next_page?" do
      results.instance_variable_set(:@attrs, {search_metadata: {next_results: nil}})
      expect(results.send(:next_page?)).to be(false)
    end

    it "uses search_metadata defaults when the key is missing" do
      attrs = Hash.new { |_hash, _key| {next_results: "?max_id=123&q=%23test"} }
      results.instance_variable_set(:@attrs, attrs)

      expect(results.send(:next_page?)).to be(true)
      expect(results.send(:next_page)).to eq(max_id: "123", q: "#test")
    end

    it "uses next_results defaults from search_metadata hashes" do
      metadata = Hash.new { |_hash, _key| "?max_id=321&q=%23fallback" }
      results.instance_variable_set(:@attrs, {search_metadata: metadata})

      expect(results.send(:next_page?)).to be(true)
      expect(results.send(:next_page)).to eq(max_id: "321", q: "#fallback")
    end
  end
end
