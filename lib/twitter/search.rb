require 'cgi'
Dir[File.expand_path('../search/*.rb', __FILE__)].each{|f| require f}

module Twitter

  # Handles the Twitter Search API
  #
  # @see http://dev.twitter.com/doc/get/search Twitter Search API docs
  class Search
    attr_accessor *Configuration::VALID_OPTIONS_KEYS
    attr_reader :fetch, :query

    # Creates a new instance of a search
    #
    # @param [String] query the optional keyword to search
    def initialize(options={})
      options = Twitter.options.merge(options)
      clear
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include Connection
    include Request
    include Authentication

    # Clears all the query filters to make a new search
    def clear
      @fetch = nil
      @query = {}
      @query[:q] = []
      self
    end

    # Search only tweets containing a keyword
    #
    # @param word [String] word by which to filter
    def containing(word)
      @query[:q] << word
      self
    end
    alias :contains :containing
    alias :q :containing

    # Search only tweets containing a keyword
    #
    # @param word [String] word by which to filter
    def not_containing(word)
      @query[:q] << "-#{word}"
      self
    end
    alias :does_not_contain :not_containing
    alias :excluding :not_containing
    alias :excludes :not_containing
    alias :exclude :not_containing

    # @group Search parameters
    #
    # Restricts tweets to the given language
    #
    # @param code [String] the ISO 639-1 language code (en, fr, de, ja, etc.)
    # @see http://en.wikipedia.org/wiki/ISO_639-1
    def language(code)
      @query[:lang] = code
      self
    end
    alias :lang :language

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
    def from(user)
      @query[:q] << "from:#{user}"
      self
    end

    # Exclude tweets from a particular user
    #
    # @param user [String] screen name of user by which to filter
    def not_from(user)
      @query[:q] << "-from:#{user}"
      self
    end

    # Search only tweets to a particular user
    #
    # @param user [String] screen name of user by which to filter
    def to(user)
      @query[:q] << "to:#{user}"
      self
    end

    # Exclude tweets to a particular user
    #
    # @param user [String] screen name of user by which to filter
    def not_to(user)
      @query[:q] << "-to:#{user}"
      self
    end

    # Search only tweets referencing a particular user
    #
    # @param user [String] screen name of user by which to filter
    def mentioning(user)
      @query[:q] << "@#{user.gsub('@', '')}"
      self
    end
    alias :referencing :mentioning
    alias :mentions :mentioning
    alias :references :mentioning

    # Search only tweets referencing a particular user
    #
    # @param user [String] screen name of user by which to filter
    def not_mentioning(user)
      @query[:q] << "-@#{user.gsub('@', '')}"
      self
    end
    alias :not_referencing :not_mentioning
    alias :does_not_mention :not_mentioning
    alias :does_not_reference :not_mentioning

    # Add a search filter
    #
    # @example
    #   Twitter::Search.new.containing('twitter').filter('links')
    #
    # @param filter [String] filter to add to the search
    def filter(filter)
      @query[:q] << "filter:#{filter}"
      self
    end

    # Only show retweets
    def retweets
      @query[:q] << "rt"
      self
    end

    # Only show original status updates (i.e., not retweets)
    def no_retweets
      @query[:q] << "-rt"
      self
    end

    # Search a hashtag
    #
    # @param tag [String] the hashtag
    def hashtag(tag)
      @query[:q] << "\##{tag.gsub('#', '')}"
      self
    end
    alias :hashed :hashtag

    # Search a hashtag
    #
    # @param tag [String] the hashtag
    def not_hashtag(tag)
      @query[:q] << "-\##{tag.gsub('#', '')}"
      self
    end
    alias :not_hashed :not_hashtag

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
    #   Twitter::Search.new.containing('twitter').since_id(123456789)
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
    #   Twitter::Search.new.containing('twitter').max_id(123456789)
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
    #   Twitter::Search.new.containing('twitter').since_date('2010-10-10')
    #
    # @param since_date [String] the search date in YYYY-MM-DD format
    def since_date(since_date)
      @query[:since] = since_date
      self
    end

    # Returns results with a date less than the specified date
    #
    # @example
    #   Twitter::Search.new.containing('twitter').until_date('2010-10-10')
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
    #   Twitter::Search.new.containing('twitter').geocode(37.781157, -122.398720, "1mi")
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
        @fetch = get("search", CGI.parse(fetch["next_page"][1..-1]))
      end
    end

    # Perform the search, hitting the API
    #
    # @param force [Boolean] optionally ignore cache and hit the API again
    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup
        query[:q] = query[:q].join(" ")
        @fetch = get("search", query)
      end
      @fetch
    end

    # Iterate over the results
    #
    # @example
    #   Twitter::Search.new.containing('twitter').each {|t| puts t.from_user}
    def each
      results = fetch['results']
      return if results.nil?
      results.each{|result| yield result}
    end

  end
end
