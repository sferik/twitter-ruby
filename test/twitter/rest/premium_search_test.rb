require "helper"

describe Twitter::REST::PremiumSearch do
  before do
    @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", dev_environment: "DE")
  end

  describe "#premium_search" do
    context "with default options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "returns a PremiumSearchResults object" do
        result = @client.premium_search("#freebandnames")
        expect(result).to be_a Twitter::PremiumSearchResults
      end

      it "uses the default maxResults of 100" do
        @client.premium_search("#freebandnames")
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}')).to have_been_made
      end

      it "uses the default product of 30day" do
        @client.premium_search("#freebandnames")
        expect(a_post("/1.1/tweets/search/30day/DE.json")).to have_been_made
      end

      it "uses json_post as the default request method" do
        @client.premium_search("#freebandnames")
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
      end
    end

    context "with custom maxResults" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":50,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses the provided maxResults" do
        @client.premium_search("#freebandnames", maxResults: 50)
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":50,"query":"#freebandnames"}')).to have_been_made
      end
    end

    context "does not mutate passed options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"tag":"test","maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "does not modify the original options hash" do
        options = {tag: "test"}
        original_options = options.dup
        @client.premium_search("#freebandnames", options)
        expect(options).to eq(original_options)
      end
    end

    context "with product: fullarchive" do
      before do
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses the fullarchive endpoint" do
        @client.premium_search("#freebandnames", {}, product: "fullarchive")
        expect(a_post("/1.1/tweets/search/fullarchive/DE.json")).to have_been_made
      end
    end

    context "with request_method: :get" do
      before do
        stub_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}).to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "makes a GET request" do
        @client.premium_search("#freebandnames", {}, request_method: :get)
        expect(a_get("/1.1/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"})).to have_been_made
      end
    end

    context "with request_method: :post" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "converts :post to :json_post" do
        @client.premium_search("#freebandnames", {}, request_method: :post)
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
      end
    end

    context "with request_method: :json_post" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses json_post directly" do
        @client.premium_search("#freebandnames", {}, request_method: :json_post)
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(headers: {"Content-Type" => "application/json; charset=utf-8"})).to have_been_made
      end
    end

    context "without request_config parameter" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "works with only query and options" do
        result = @client.premium_search("test", {})
        expect(result).to be_a Twitter::PremiumSearchResults
      end
    end

    context "with empty request_config" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses defaults for empty request_config" do
        result = @client.premium_search("test", {}, {})
        expect(result).to be_a Twitter::PremiumSearchResults
      end
    end

    context "query is merged into options" do
      before do
        stub_post("/1.1/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"test"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "includes query in the request body" do
        @client.premium_search("test")
        expect(a_post("/1.1/tweets/search/30day/DE.json").with(body: /"query":"test"/)).to have_been_made
      end
    end

    context "pagination with request_config" do
      before do
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"pizza"}').to_return(body: fixture("premium_search_next.json"), headers: {content_type: "application/json; charset=utf-8"})
        stub_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}').to_return(body: fixture("premium_search_last.json"), headers: {content_type: "application/json; charset=utf-8"})
      end

      it "uses the correct product for paginated requests" do
        @client.premium_search("pizza", {}, product: "fullarchive").each {}
        expect(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"pizza"}')).to have_been_made
        expect(a_post("/1.1/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}')).to have_been_made
      end
    end
  end
end
