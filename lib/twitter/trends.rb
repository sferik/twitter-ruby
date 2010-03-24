module Twitter
  class Trends
    include HTTParty
    base_uri "api.twitter.com/#{API_VERSION}/trends"
    format :json

    # :exclude => 'hashtags' to exclude hashtags
    def self.current(options={})
      mashup(get("/current.json", :query => options))
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.daily(options={})
      mashup(get("/daily.json", :query => options))
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.weekly(options={})
      mashup(get("/weekly.json", :query => options))
    end

    def self.available(query={})
      get("/available.json", :query => query).map{|location| Twitter.mash(location)}
    end

    def self.for_location(woeid)
      get("/#{woeid}.json").map{|location| Twitter.mash(location)}
    end

    private

    def self.mashup(response)
      response["trends"].values.flatten.map{|t| Twitter.mash(t)}
    end

  end
end
