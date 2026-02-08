require "test_helper"

PremiumSearchRequestDouble = Struct.new(:client, :verb, :path, :options, :perform_result, keyword_init: true) do
  def perform
    perform_result
  end
end

describe Twitter::PremiumSearchResults do
  let(:client) { Object.new }
  let(:request_options) { {query: "pizza", from_date: "202401010000"} }
  let(:initial_attrs) { {results: [{id: 1, text: "one"}], next: "next-token"} }

  def build_request(client:, verb:, path:, options:, perform_result:)
    PremiumSearchRequestDouble.new(client:, verb:, path:, options:, perform_result:)
  end

  def assert_premium_search_called(client:, expected_query:, expected_options:, expected_config:, return_value:)
    premium_search = Minitest::Mock.new
    premium_search.expect(:call, return_value, [expected_query, expected_options, expected_config])
    client.define_singleton_method(:premium_search) { |query, options, config| premium_search.call(query, options, config) }
    yield
    premium_search.verify
  end

  let(:request) do
    build_request(
      client:,
      verb: :post,
      path: "/1.1/tweets/search/30day/DE.json",
      options: request_options,
      perform_result: initial_attrs
    )
  end

  describe "#initialize" do
    it "defaults request_config to an empty hash" do
      results = Twitter::PremiumSearchResults.new(request)

      assert_empty(results.instance_variable_get(:@request_config))
      assert_equal(:post, results.instance_variable_get(:@request_method))
      assert_equal("/1.1/tweets/search/30day/DE.json", results.instance_variable_get(:@path))
    end

    it "preserves an explicit request_config" do
      config = {request_method: :get}
      results = Twitter::PremiumSearchResults.new(request, config)

      assert_equal(config, results.instance_variable_get(:@request_config))
    end
  end

  describe "private pagination helpers" do
    it "returns a strict boolean for next_page? and treats nil next as false" do
      without_next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: []}
      )
      with_nil_next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: [], next: nil}
      )
      without_next = Twitter::PremiumSearchResults.new(without_next_request)
      with_nil_next = Twitter::PremiumSearchResults.new(with_nil_next_request)
      with_next = Twitter::PremiumSearchResults.new(request)

      assert_false(without_next.send(:next_page?))
      assert_false(with_nil_next.send(:next_page?))
      assert_predicate(with_next, :next_page?)
    end

    it "returns a next-page hash only when there is a next page" do
      without_next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: []}
      )
      without_next = Twitter::PremiumSearchResults.new(without_next_request)
      with_next = Twitter::PremiumSearchResults.new(request)

      assert_nil(without_next.send(:next_page))
      assert_equal({next: "next-token"}, with_next.send(:next_page))
    end

    it "requests the next page using query and merged next token" do
      results = Twitter::PremiumSearchResults.new(request, {request_method: :post})
      next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: [{id: 2, text: "two"}]}
      )
      next_results = Twitter::PremiumSearchResults.new(next_request)

      assert_premium_search_called(
        client:,
        expected_query: "pizza",
        expected_options: {from_date: "202401010000", next: "next-token"},
        expected_config: {request_method: :post},
        return_value: next_results
      ) do
        results.send(:fetch_next_page)
      end

      assert_equal({query: "pizza", from_date: "202401010000"}, request_options)
      assert_equal([1, 2], results.to_a.map(&:id))
    end

    it "passes nil query when query is not present in options" do
      request_without_query = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: {from_date: "202401010000"},
        perform_result: {results: [{id: 1}], next: "next-token"}
      )
      results = Twitter::PremiumSearchResults.new(request_without_query)
      nil_query_next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: {from_date: "202401010000"},
        perform_result: {results: [{id: 2}]}
      )
      next_results = Twitter::PremiumSearchResults.new(nil_query_next_request)

      assert_premium_search_called(
        client:,
        expected_query: nil,
        expected_options: {from_date: "202401010000", next: "next-token"},
        expected_config: {},
        return_value: next_results
      ) do
        results.send(:fetch_next_page)
      end

      assert_equal([1, 2], results.to_a.map(&:id))
    end

    it "treats missing next_page data as an empty merge when fetching the next page" do
      request_without_next = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: [{id: 1, text: "one"}]}
      )
      results = Twitter::PremiumSearchResults.new(request_without_next)
      no_next_request = build_request(
        client:,
        verb: :post,
        path: "/path",
        options: request_options,
        perform_result: {results: [{id: 2, text: "two"}]}
      )
      next_results = Twitter::PremiumSearchResults.new(no_next_request)

      assert_nothing_raised do
        assert_premium_search_called(
          client:,
          expected_query: "pizza",
          expected_options: {from_date: "202401010000"},
          expected_config: {},
          return_value: next_results
        ) do
          results.send(:fetch_next_page)
        end
      end

      assert_equal([1, 2], results.to_a.map(&:id))
    end
  end

  describe "private attrs= behavior" do
    it "converts each result to Tweet objects and returns attrs" do
      results = Twitter::PremiumSearchResults.new(request)

      attrs = results.send(:attrs=, {results: [{id: 2, text: "two"}]})

      assert_equal({results: [{id: 2, text: "two"}]}, attrs)
      assert_kind_of(Twitter::Tweet, results.to_a.last)
      assert_equal(2, results.to_a.last.id)
    end

    it "accepts missing :results and does not raise" do
      results = Twitter::PremiumSearchResults.new(request)

      assert_nothing_raised { results.send(:attrs=, {}) }
      assert_empty(results.send(:attrs=, {}))
    end
  end

  describe "#each" do
    before do
      @client = build_rest_client(dev_environment: "DE")
    end

    it "requests the correct resources" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      @client.premium_search("#freebandnames").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports GET requests" do
      stub_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}).to_return(body: fixture("premium_search.json"), headers: json_headers)
      @client.premium_search("#freebandnames", {}, request_method: :get).each {}

      assert_requested(a_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}))
    end

    it "supports POST requests" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      @client.premium_search("#freebandnames", {}, request_method: :post).each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "iterates" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      count = 0
      @client.premium_search("#freebandnames").each { count += 1 }

      assert_equal(1, count)
    end

    it "paginates" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}').to_return(body: fixture("premium_search_next.json"), headers: json_headers)
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}').to_return(body: fixture("premium_search_last.json"), headers: json_headers)
      @client.premium_search("pizza").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports emoji" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}').to_return(body: fixture("premium_search_emoji.json"), headers: json_headers)
      @client.premium_search("🍕").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports from operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}').to_return(body: fixture("premium_search_from.json"), headers: json_headers)
      @client.premium_search("from:twitterdev").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports to operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}').to_return(body: fixture("premium_search_to.json"), headers: json_headers)
      @client.premium_search("to:twitterdev").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports point_radius operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}').to_return(body: fixture("premium_search_point_radius.json"), headers: json_headers)
      @client.premium_search("point_radius:[-105.27346517 40.01924738 10.0mi]").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports url operator" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: json_headers)
      @client.premium_search("url:github.com/sferik/twitter").each {}

      assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end

    it "supports product fullarchive" do
      stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: json_headers)
      @client.premium_search("url:github.com/sferik/twitter", {}, product: "fullarchive").each {}

      assert_requested(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=utf-8"}))
    end
  end

  describe "#next_page" do
    before do
      @client = build_rest_client(dev_environment: "DE")
    end

    it "returns nil when there is no next page" do
      stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#test"}').to_return(body: '{"results":[]}', headers: json_headers)
      results = @client.premium_search("#test")

      assert_nil(results.send(:next_page))
    end
  end
end
