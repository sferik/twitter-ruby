require File.join(File.expand_path(File.dirname(__FILE__)), "local_trends")

module Twitter
  class Trends
    include HTTParty
    base_uri "search.twitter.com/trends"
    format :json

    # :exclude => 'hashtags' to exclude hashtags
    def self.current(options={})
      before_test(options)
      options.delete(:api_endpoint)		   
      mashup(get("/current.json", :query => options))
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.daily(options={})
      before_test(options)
      options.delete(:api_endpoint)		   
      mashup(get("/daily.json", :query => options))
    end

    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.weekly(options={})
      before_test(options)
      options.delete(:api_endpoint)
      mashup(get("/weekly.json", :query => options))
    end

    def self.available(query={})
      #checking for api_endpoint in local_trends
      LocalTrends.available(query)
    end

    def self.for_location(woeid,options={})
      #checking for api_endpoint in local_trends 
      LocalTrends.for_location(woeid,options)
    end

    private

    def self.mashup(response)
      response["trends"].values.flatten.map{|t| Twitter.mash(t)}
    end

    def self.before_test(options)
      configure_base_uri(options)
    end

    def self.configure_base_uri(options)
      new_base_url = options[:api_endpoint] 	
      base_uri "#{new_base_url}/trends" if new_base_url
    end	

  end
end
