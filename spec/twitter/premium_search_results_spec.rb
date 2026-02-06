require "helper"

describe Twitter::PremiumSearchResults do
  let(:client) { instance_double(Twitter::REST::Client) }
  let(:request_options) { {query: "pizza", from_date: "202401010000"} }
  let(:initial_attrs) { {results: [{id: 1, text: "one"}], next: "next-token"} }
  let(:request) do
    instance_double(
      Twitter::REST::Request,
      client:,
      verb: :post,
      path: "/1.1/tweets/search/30day/DE.json",
      options: request_options,
      perform: initial_attrs
    )
  end

  describe "#initialize" do
    it "defaults request_config to an empty hash" do
      results = described_class.new(request)

      expect(results.instance_variable_get(:@request_config)).to eq({})
      expect(results.instance_variable_get(:@request_method)).to eq(:post)
      expect(results.instance_variable_get(:@path)).to eq("/1.1/tweets/search/30day/DE.json")
    end

    it "preserves an explicit request_config" do
      config = {request_method: :get}
      results = described_class.new(request, config)

      expect(results.instance_variable_get(:@request_config)).to eq(config)
    end
  end

  describe "private pagination helpers" do
    it "returns a strict boolean for next_page? and treats nil next as false" do
      without_next = described_class.new(instance_double(Twitter::REST::Request, client:, verb: :post, path: "/path", options: request_options, perform: {results: []}))
      with_nil_next = described_class.new(instance_double(Twitter::REST::Request, client:, verb: :post, path: "/path", options: request_options, perform: {results: [], next: nil}))
      with_next = described_class.new(request)

      expect(without_next.send(:next_page?)).to be(false)
      expect(with_nil_next.send(:next_page?)).to be(false)
      expect(with_next.send(:next_page?)).to be(true)
    end

    it "returns a next-page hash only when there is a next page" do
      without_next = described_class.new(instance_double(Twitter::REST::Request, client:, verb: :post, path: "/path", options: request_options, perform: {results: []}))
      with_next = described_class.new(request)

      expect(without_next.send(:next_page)).to be_nil
      expect(with_next.send(:next_page)).to eq(next: "next-token")
    end

    it "requests the next page using query and merged next token" do
      results = described_class.new(request, {request_method: :post})
      next_results = described_class.new(
        instance_double(Twitter::REST::Request, client:, verb: :post, path: "/path", options: request_options, perform: {results: [{id: 2, text: "two"}]})
      )

      expect(client).to receive(:premium_search).with("pizza", {from_date: "202401010000", next: "next-token"}, {request_method: :post}).and_return(next_results)
      results.send(:fetch_next_page)
      expect(results.to_a.map(&:id)).to eq([1, 2])
    end

    it "passes nil query when query is not present in options" do
      request_without_query = instance_double(
        Twitter::REST::Request,
        client:,
        verb: :post,
        path: "/path",
        options: {from_date: "202401010000"},
        perform: {results: [{id: 1}], next: "next-token"}
      )
      results = described_class.new(request_without_query)
      next_results = described_class.new(
        instance_double(Twitter::REST::Request, client:, verb: :post, path: "/path", options: {from_date: "202401010000"}, perform: {results: [{id: 2}]})
      )

      expect(client).to receive(:premium_search).with(nil, {from_date: "202401010000", next: "next-token"}, {}).and_return(next_results)
      results.send(:fetch_next_page)
      expect(results.to_a.map(&:id)).to eq([1, 2])
    end
  end

  describe "private attrs= behavior" do
    it "converts each result to Tweet objects and returns attrs" do
      results = described_class.new(request)

      attrs = results.send(:attrs=, {results: [{id: 2, text: "two"}]})
      expect(attrs).to eq(results: [{id: 2, text: "two"}])
      expect(results.to_a.last).to be_a(Twitter::Tweet)
      expect(results.to_a.last.id).to eq(2)
    end

    it "accepts missing :results and does not raise" do
      results = described_class.new(request)

      expect { results.send(:attrs=, {}) }.not_to raise_error
      expect(results.send(:attrs=, {})).to eq({})
    end
  end

  describe "#each" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", dev_environment: "DE")
    end

    it "requests the correct resources" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("#freebandnames").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports GET requests" do
      stub_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}).to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("#freebandnames", {}, request_method: :get).each {}
      expect(a_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"})).to have_been_made
    end

    it "supports POST requests" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("#freebandnames", {}, request_method: :post).each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "iterates" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      count = 0
      @client.premium_search("#freebandnames").each { count += 1 }
      expect(count).to eq(1)
    end

    it "paginates" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}').to_return(body: fixture("premium_search_next.json"), headers: {content_type: "application/json; charset=utf-8"})
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}').to_return(body: fixture("premium_search_last.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("pizza").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports emoji" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}').to_return(body: fixture("premium_search_emoji.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("🍕").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports from operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}').to_return(body: fixture("premium_search_from.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("from:twitterdev").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports to operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}').to_return(body: fixture("premium_search_to.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("to:twitterdev").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports point_radius operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}').to_return(body: fixture("premium_search_point_radius.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("point_radius:[-105.27346517 40.01924738 10.0mi]").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports url operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("url:github.com/sferik/twitter").each {}
      expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end

    it "supports product fullarchive" do
      stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: {content_type: "application/json; charset=utf-8"})
      @client.premium_search("url:github.com/sferik/twitter", {}, product: "fullarchive").each {}
      expect(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
    end
  end

  describe "#next_page" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", dev_environment: "DE")
    end

    it "returns nil when there is no next page" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#test"}').to_return(body: '{"results":[]}', headers: {content_type: "application/json; charset=utf-8"})
      results = @client.premium_search("#test")
      expect(results.send(:next_page)).to be_nil
    end
  end
end
