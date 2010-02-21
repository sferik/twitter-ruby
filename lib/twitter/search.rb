module Twitter
  class Search
    include HTTParty
    include Enumerable

    attr_reader :result, :query

    def initialize(q=nil, options={})
      @options = options
      clear
      containing(q) if q && q.strip != ''
    end

    def user_agent
      @options[:user_agent] || 'Ruby Twitter Gem'
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
    
    # Search for a phrase instead of a group of words
    def phrase(phrase)
      @query[:phrase] = phrase
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

    # Which page of results to fetch
    def page(num)
      @query[:page] = num
      self
    end

    # Only searches tweets since a given id.
    # Recommended to use this when possible.
    def since(since_id)
      @query[:since_id] = since_id
      self
    end
    
    # From the advanced search form, not documented in the API
    # Format YYYY-MM-DD
    def since_date(since_date)
      @query[:since] = since_date
      self
    end

    # From the advanced search form, not documented in the API
    # Format YYYY-MM-DD
    def until_date(until_date)
      @query[:until] = until_date
      self
    end

    # Ranges like 25km and 50mi work.
    def geocode(lat, long, range)
      @query[:geocode] = [lat, long, range].join(',')
      self
    end

    def max(id)
      @query[:max_id] = id
      self
    end

    # Clears all the query filters to make a new search
    def clear
      @fetch = nil
      @query = {}
      @query[:q] = []
      self
    end

    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup
        query[:q] = query[:q].join(' ')
        perform_get(query)
      end

      @fetch
    end

    def each
      fetch()['results'].each { |r| yield r }
    end

    def next_page?
      !!fetch()['next_page']
    end

    def fetch_next_page
      if next_page?
        s = Search.new(nil, :user_agent => user_agent)
        s.perform_get(fetch()['next_page'][1..-1])
        s
      end
    end

    protected
      def perform_get(query)
        response = self.class.get('http://search.twitter.com/search.json', :query => query, :format => :json, :headers => {'User-Agent' => user_agent})
        @fetch = Hashie::Mash.new(response)
      end
  end
end
