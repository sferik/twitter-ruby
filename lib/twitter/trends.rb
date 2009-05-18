module Twitter
  class Trends
    include HTTParty
    base_uri 'search.twitter.com/trends'
    format :json
    
    # :exclude => 'hashtags' to exclude hashtags
    def self.current(options={})
      response = get('/current.json', :query => options)
      response['trends'].values.flatten.map { |t| Mash.new(t) }
    end
  end
end