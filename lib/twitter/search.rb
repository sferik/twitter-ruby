module Twitter

  # Handles the Twitter Search API
  #
  # @see http://dev.twitter.com/doc/get/search Twitter Search API docs
  class Search
    include Enumerable
    attr_reader :result, :query

    # Creates a new instance of a search
    #
    # @param [String] q the optional keyword to search
    # @option options [String] :api_endpoint an alternative API endpoint such as Apigee
    # @option options [String] :user_agent The user agent passed to Twitter. Default: 'Ruby Twitter Gem'
    def initialize(q=nil, options={})
      @adapter = options.delete(:adapter)
      @options = options
      clear
      containing(q) if q && q.strip != ""
      @api_endpoint = "search.twitter.com/search.#{Twitter.format}"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
    end

    # Returns the configured user agent for the search
    # @return <String> the configured user agent
    def user_agent
      @options[:user_agent] || "Ruby Twitter Gem"
    end
    
    # Clears all the query filters to make a new search
    def clear
      @fetch = nil
      @query = {}
      @query[:q] = []
      self
    end

    # @group Search parameters
    #
    # Restricts tweets to the given language
    #
    # @param lang [String] the ISO 639-1 language code (en, fr, de, ja, etc.)
    # @see http://en.wikipedia.org/wiki/ISO_639-1
    def lang(lang)
      @query[:lang] = lang
      self
    end

    # Specify the language of the query you are sending 
    # (only ja is currently effective). This is intended for 
    # language-specific clients and the default should work in 
    # the majority of cases.
    #
    # @param locale [String] the language code for your query
    def locale(locale)
      @query[:locale] = locale
      self
    end

    # Search only tweets from a particular user
    #
    # @param user [String] screen name of user by which to filter
    # @param exclude [Boolean] optionally exclude tweets from this user
    def from(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}from:#{user}"
      self
    end

    # Search only tweets to a particular user
    #
    # @param user [String] screen name of user by which to filter
    # @param exclude [Boolean] optionally exclude tweets to this user
    def to(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}to:#{user}"
      self
    end

    # Search only tweets referencing a particular user
    #
    # @param user [String] screen name of user by which to filter
    # @param exclude [Boolean] optionally exclude tweets referencing this user
    def referencing(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}@#{user}"
      self
    end
    alias :references :referencing
    alias :ref :referencing

    # Search only tweets containing a keyword
    #
    # @param word [String] word by which to filter
    # @param exclude [Boolean] optionally exclude tweets with this word
    def containing(word, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}#{word}"
      self
    end
    alias :contains :containing

    # Add a search filter
    #
    # @example
    #   Twitter::Search.new('ruby').filter('links')
    #
    # @param filter [String] filter to add to the search
    def filter(filter)
      @query[:q] << "filter:#{filter}"
      self
    end

    # Show only retweets
    def retweeted
      @query[:q] << "rt"
      self
    end

    # Show only non retweets
    def not_retweeted
      @query[:q] << "-rt"
      self
    end

    # Search a hashtag
    #
    # @param tag [String] the hashtag
    # @param exclude [Boolean] optionally exclude this hashtag
    def hashed(tag, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}\##{tag}"
      self
    end

    # Search for a phrase instead of a group of words
    #
    # @param phrase [String] the search phrase
    def phrase(phrase)
      @query[:phrase] = phrase
      self
    end

    # Specifies what type of search results you would prefer to receive
    #
    # @param result_type [String] the results you want to receive: 'mixed', 'recent', 'popular'
    def result_type(result_type='mixed')
      @query[:result_type] = result_type
      self
    end

    # Returns results with an ID greater than (that is, more recent than)
    # the specified ID.
    #
    # @example
    #   Twitter::Search.new('ruby').since_id(123456789)
    #
    # @param id [Integer] the status ID of the tweet after which to search
    def since_id(id)
      @query[:since_id] = id
      self
    end
    alias :since :since_id

    # Returns results with an ID less than (that is, older than)
    # the specified ID.
    #
    # @example
    #   Twitter::Search.new('ruby').max_id(123456789)
    #
    # @param id [Integer] the status ID of the tweet before which to search
    def max_id(id)
      @query[:max_id] = id
      self
    end
    alias :max :max_id

    # Returns results with a date greater than the specified date
    #
    # ** From the advanced search form, not documented in the API
    # Format: YYYY-MM-DD
    #
    # @example
    #   Twitter::Search.new('ruby').since_date('2010-10-09')
    #
    # @param since_date [String] the search date in YYYY-MM-DD format
    def since_date(since_date)
      @query[:since] = since_date
      self
    end

    # Returns results with a date less than the specified date
    #
    # @example
    #   Twitter::Search.new('ruby').until_date('2010-10-09')
    #
    # @param until_date [String] the search date in YYYY-MM-DD format
    def until_date(until_date)
      @query[:until] = until_date
      self
    end
    alias :until :until_date

    # Returns tweets by users located within a given radius of the 
    # given latitude/longitude.
    #
    # @example
    #   Twitter::Search.new('ruby').geocode(37.781157, -122.398720, "1mi")
    #
    # @param lat [Float] the latitude to search
    # @param long [Float] the longitude to search
    # @param range [String] the radius of the search in either 'mi' or 'km'
    def geocode(lat, long, range)
      @query[:geocode] = [lat, long, range].join(",")
      self
    end

    # @group Paging
    #
    # The number of tweets to return per page
    #
    # @param num [Integer] the number of tweets per page, maximum 100
    def per_page(num)
      @query[:rpp] = num
      self
    end
    alias :rpp :per_page

    # The page number (starting at 1) to return, up to a max of roughly 1500 results
    #
    # @param page [Integer] the page number to return
    def page(num)
      @query[:page] = num
      self
    end
    
    # Indicates if the results have more to be fetched
    def next_page?
      !!fetch["next_page"]
    end

    # @group Fetching
    #
    # Fetch the next page of results in the query
    def fetch_next_page
      if next_page?
        s = Search.new(nil, :user_agent => user_agent)
        s.perform_get(fetch["next_page"][1..-1])
        s
      end
    end

    # Perform the search, hitting the API
    #
    # @param force [Boolean] optionally ignore cache and hit the API again
    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup
        query[:q] = query[:q].join(" ")
        perform_get(query)
      end

      @fetch
    end

    # Iterate over the results
    #
    # @example
    #   Twitter::Search.new('ruby').each {|t| puts t.from_user}
    def each
      results = fetch['results']
      return if results.nil?
      results.each {|r| yield r}
    end

    private

    def connection
      headers = {:user_agent => Twitter.user_agent}
      ssl = {:verify => false}
      @connection = Faraday::Connection.new(:url => @api_endpoint.omit(:path), :headers => headers, :ssl => false) do |builder|
        builder.adapter(@adapter || Faraday.default_adapter)
        builder.use Faraday::Response::RaiseErrors
        case Twitter.format.to_s
        when "json"
          builder.use Faraday::Response::ParseJson
        when "xml"
          builder.use Faraday::Response::ParseXml
        end
        builder.use Faraday::Response::Mashify
      end
      @connection.scheme = Twitter.scheme
      @connection
    end

    protected

    # @private
    def perform_get(query)
      @fetch = connection.get do |request|
        request.url @api_endpoint.path, query
      end.body
    end

  end
end
