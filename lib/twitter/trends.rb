module Twitter
  class Trends
    include HTTParty
    base_uri 'search.twitter.com/trends'
    format :json
    
    # :exclude => 'hashtags' to exclude hashtags
    def self.current(options={})
      mashup(get('/current.json', :query => options))
    end
    
    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.daily(options={})
      mashup(get('/daily.json', :query => options))
    end
    
    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.weekly(options={})
      mashup(get('/weekly.json', :query => options))
    end
    
    private
      def self.mashup(response)
        response['trends'].values.flatten.map { |t| Mash.new(t) }
      end
  end
end