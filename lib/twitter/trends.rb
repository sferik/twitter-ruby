require File.join(File.expand_path(File.dirname(__FILE__)), "local_trends")

module Twitter
  class Trends
    include HTTParty
    base_uri "search.twitter.com/trends"
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
      LocalTrends.available(query)
    end

    def self.for_location(woeid)
      LocalTrends.for_location(woeid)
    end

    private

    def self.mashup(response)
      response["trends"].values.flatten.map{|t| Twitter.mash(t)}
    end

  end
end
