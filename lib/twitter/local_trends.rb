module Twitter
  class LocalTrends
    include HTTParty
    base_uri "api.twitter.com/#{API_VERSION}/trends"
    format :json

    def self.available(query={})
      get("/available.json", :query => query).map{|location| Twitter.mash(location)}
    end

    def self.for_location(woeid)
      get("/#{woeid}.json").map{|location| Twitter.mash(location)}
    end
  end
end
