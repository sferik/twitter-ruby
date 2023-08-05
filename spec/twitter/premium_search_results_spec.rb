require "helper"

describe Twitter::PremiumSearchResults do
  describe "#each" do
    before do
      @client = Twitter::REST::Client.new(consumer_key: "CK", consumer_secret: "CS", access_token: "AT", access_token_secret: "AS", dev_environment: "DE")
    end

    it "requests the correct resources" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("#freebandnames").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports GET requests" do
      stub_get("/2/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"}).to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("#freebandnames", {}, request_method: :get).each {}
      expect(a_get("/2/tweets/search/30day/DE.json").with(query: {query: "#freebandnames", maxResults: "100"})).to have_been_made
    end

    it "supports POST requests" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("#freebandnames", {}, request_method: :post).each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "iterates" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"#freebandnames"}').to_return(body: fixture("premium_search.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      count = 0
      @client.premium_search("#freebandnames").each { count += 1 }
      expect(count).to eq(1)
    end

    it "paginates" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}').to_return(body: fixture("premium_search_next.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}').to_return(body: fixture("premium_search_last.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("pizza").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"pizza"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"next":"eyJhdXRoZW50aWNpdHkiOiI3MzdlZGI5ZjMwNDcwZjlhMWU1OGFhNWVkNzEyOGI4NGIyMWY2YTA3NTE3NTlhNWQxZGYxMjRiOGQ2ZmM5MjQwIiwiZnJvbURhdGUiOiIyMDE3MTAyMDAwMDAiLCJ0b0RhdGUiOiIyMDE3MTExOTIzMTUiLCJuZXh0IjoiMjAxNzExMTkyMzEyMzEtOTMyMzg2MTMxODEwODg5NzI4LTAifQ==","query":"pizza"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports emoji" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}').to_return(body: fixture("premium_search_emoji.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("🍕").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"🍕"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports from operator" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}').to_return(body: fixture("premium_search_from.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("from:twitterdev").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"from:twitterdev"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports to operator" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}').to_return(body: fixture("premium_search_to.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("to:twitterdev").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"to:twitterdev"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports point_radius operator" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}').to_return(body: fixture("premium_search_point_radius.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("point_radius:[-105.27346517 40.01924738 10.0mi]").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"point_radius:[-105.27346517 40.01924738 10.0mi]"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports url operator" do
      stub_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("url:github.com/sferik/twitter").each {}
      expect(a_post("/2/tweets/search/30day/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end

    it "supports product fullarchive" do
      stub_post("/2/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}').to_return(body: fixture("premium_search_url.json"), headers: {content_type: "application/json; charset=UTF-8; charset=utf-8"})
      @client.premium_search("url:github.com/sferik/twitter", {}, product: "fullarchive").each {}
      expect(a_post("/2/tweets/search/fullarchive/DE.json").with(body: '{"maxResults":100,"query":"url:github.com/sferik/twitter"}', headers: {"Content-Type" => "application/json; charset=UTF-8"})).to have_been_made
    end
  end
end
