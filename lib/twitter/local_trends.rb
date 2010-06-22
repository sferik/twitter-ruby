module Twitter
  class LocalTrends
    include HTTParty
    base_uri "api.twitter.com/#{API_VERSION}/trends"
    format :json

    def self.available(query={})
      before_test(query)
      query.delete(:api_endpoint)
      get("/available.json", :query => query).map{|location| Twitter.mash(location)}
    end

    def self.for_location(woeid,options = {})
      before_test(options)
      get("/#{woeid}.json").map{|location| Twitter.mash(location)}
    end

    private
    
    def self.before_test(options)
      configure_base_uri(options)
    end

    def self.configure_base_uri(options)
      new_base_url = options[:api_endpoint]
      base_uri "#{new_base_url}/#{API_VERSION}/trends" if new_base_url
    end

  end
end
