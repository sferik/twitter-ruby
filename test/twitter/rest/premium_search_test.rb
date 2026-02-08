require "test_helper"

describe Twitter::REST::PremiumSearch do
  before do
    @client = build_rest_client(dev_environment: "DE")
  end

  describe "#premium_search" do
    describe "with default options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "returns a PremiumSearchResults object" do
        result = @client.premium_search("#freebandnames")

        assert_kind_of(Twitter::PremiumSearchResults, result)
      end

      it "uses the default maxResults of 100" do
        @client.premium_search("#freebandnames")

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}'))
      end

      it "uses the default product of 30day" do
        @client.premium_search("#freebandnames")

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json"))
      end

      it "uses json_post as the default request method" do
        @client.premium_search("#freebandnames")

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"}))
      end
    end

    describe "with custom maxResults" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":50,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "uses the provided maxResults" do
        @client.premium_search("#freebandnames", maxResults: 50)

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":50,"query":"#freebandnames"}'))
      end
    end

    describe "does not mutate passed options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"tag":"test","maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "does not modify the original options hash" do
        options = {tag: "test"}
        original_options = options.dup
        @client.premium_search("#freebandnames", options)

        assert_equal(original_options, options)
      end
    end

    describe "with product: fullarchive" do
      before do
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "uses the fullarchive endpoint" do
        @client.premium_search("#freebandnames", {}, product: "fullarchive")

        assert_requested(a_post("/1.1/tweets/search/fullarchive/DE.json"))
      end
    end

    describe "with request_method: :get" do
      before do
        stub_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}).to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "makes a GET request" do
        @client.premium_search("#freebandnames", {}, request_method: :get)

        assert_requested(a_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}))
      end
    end

    describe "with request_method: :post" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "converts :post to :json_post" do
        @client.premium_search("#freebandnames", {}, request_method: :post)

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"}))
      end
    end

    describe "with request_method: :json_post" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "uses json_post directly" do
        @client.premium_search("#freebandnames", {}, request_method: :json_post)

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"}))
      end
    end

    describe "without request_config parameter" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "works with only query and options" do
        result = @client.premium_search("test", {})

        assert_kind_of(Twitter::PremiumSearchResults, result)
      end
    end

    describe "with empty request_config" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "uses defaults for empty request_config" do
        result = @client.premium_search("test", {}, {})

        assert_kind_of(Twitter::PremiumSearchResults, result)
      end
    end

    describe "query is merged into options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: json_headers)
      end

      it "includes query in the request body" do
        @client.premium_search("test")

        assert_requested(a_post("/1.1/tweets/search/30day/DE.json").with(body: /"query":"test"/))
      end
    end

    describe "pagination with request_config" do
      before do
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"pizza"}').to_return(body: fixture("premium_search_next.json"), headers: json_headers)
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}').to_return(body: fixture("premium_search_last.json"), headers: json_headers)
      end

      it "uses the correct product for paginated requests" do
        @client.premium_search("pizza", {}, product: "fullarchive").each {}

        assert_requested(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"pizza"}'))
        assert_requested(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}'))
      end
    end
  end
end
