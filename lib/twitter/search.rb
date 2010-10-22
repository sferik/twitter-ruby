module Twitter

  # Handles the Twitter Search API
  #
  # @see http://dev.twitter.com/doc/get/search Twitter Search API docs
  class Search
    extend ConfigHelper
    include ConnectionHelper
    include Enumerable
    include RequestHelper
    attr_reader :oauth_token, :access_secret, :consumer_key, :consumer_secret, :query, :result

    # Creates a new instance of a search
    #
    # @param [String] query the optional keyword to search
    def initialize(query=nil, options={})
      @consumer_key = options[:consumer_key] || Twitter.consumer_key
      @consumer_secret = options[:consumer_secret] || Twitter.consumer_secret
      @oauth_token = options[:oauth_token] || Twitter.oauth_token
      @access_secret = options[:access_secret] || Twitter.access_secret
      @adapter = options[:adapter] || Twitter.adapter
      @api_endpoint = options[:api_endpoint] || Twitter.api_endpoint
      @api_version = options[:api_version] || Twitter.api_version
      @format = Twitter.default_format
      @protocol = options[:protocol] || Twitter.protocol
      @user_agent = options[:user_agent] || Twitter.user_agent
      clear
      containing(query) if query && query.strip != ""
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
        search = Search.new
        search.perform_get("search.#{self.class.format}", fetch["next_page"][1..-1])
        search
      end
    end

    # Perform the search, hitting the API
    #
    # @param force [Boolean] optionally ignore cache and hit the API again
    def fetch
      query = @query.dup
      query[:q] = query[:q].join(" ")
      perform_get("search.#{self.class.format}", query)
    end

    # Iterate over the results
    #
    # @example
    #   Twitter::Search.new('ruby').each {|t| puts t.from_user}
    def each
      results = fetch['results']
      return if results.nil?
      results.each{|result| yield result}
    end

  end
end
