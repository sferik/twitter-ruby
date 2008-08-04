gem 'httparty'
require 'httparty'

module Twitter
  class Search
    include HTTParty
    include Enumerable
    base_uri 'search.twitter.com'
    
    attr_reader :result, :query
    
    def initialize(q=nil)
      clear
      containing(q) unless q.blank?
    end
    
    def from(user)
      @query[:q] << "from:#{user}"
      self
    end
    
    def to(user)
      @query[:q] << "to:#{user}"
      self
    end
    
    def referencing(user)
      @query[:q] << "@#{user}"
      self
    end
    alias :references :referencing
    alias :ref :referencing
    
    def containing(word)
      @query[:q] << "#{word}"
      self
    end
    alias :contains :containing
    
    # adds filtering based on hash tag ie: #twitter
    def hashed(tag)
      @query[:q] << "##{tag}"
      self
    end
    
    # lang must be ISO 639-1 code ie: en, fr, de, ja, etc.
    #
    # when I tried en it limited my results a lot and took 
    # out several tweets that were english so i'd avoid 
    # this unless you really want it
    def lang(lang)
      @query[:lang] = lang
      self
    end
    
    # Limits the number of results per page
    def per_page(num)
      @query[:rpp] = num
      self
    end
    
    # Only searches tweets since a given id. 
    # Recommended to use this when possible.
    def since(since_id)
      @query[:since_id] = since_id
      self
    end
    
    # Search tweets by longitude, latitude and a given range.
    # Ranges like 25km and 50mi work.
    def geocode(long, lat, range)
      @query[:geocode] = [long, lat, range].join(',')
      self
    end
    
    # Clears all the query filters to make a new search
    def clear
      @query = {}
      @query[:q] = []
      self
    end
    
    # If you want to get results do something other than iterate over them.
    def fetch
      @query[:q] = @query[:q].join(' ')
      self.class.get('/search.json', {:query => @query})
    end
    
    def each
      @result = fetch()
      @result['results'].each { |r| yield r }
    end
  end
end