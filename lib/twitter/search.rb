require 'cgi'

module Twitter

  # Wrapper for the Twitter Search API.
  #
  # *Notice*: As of April 1st 2010, the Search API provides an option to retrieve
  # "popular tweets" in addition to real-time search results. In an upcoming release,
  # this will become the default and clients that don't want to receive popular tweets
  # in their search results will have to explicitly opt-out. See {Twitter::Search#result_type}
  # for more information.
  #
  # *Warning*: The user ids in the Search API are different from those in the REST API
  # ({http://dev.twitter.com/pages/api_overview about the two APIs}). This defect is
  # being tracked by {http://code.google.com/p/twitter-api/issues/detail?id=214 Issue 214}.
  # This means that the to_user_id and from_user_id field vary from the actualy user id on
  # Twitter.com. Applications will have to perform a screen name-based lookup with
  # {Twitter::Client::User#user} to get the correct user id if necessary.
  # @see http://dev.twitter.com/doc/get/search Twitter Search API Documentation
  class Search < API
    attr_reader :query

    # Creates a new search
    def initialize(*)
      clear
      super
    end

    alias :api_endpoint :search_endpoint

    # Clears all query filters and cached results
    #
    # @return [Twitter::Search] self
    # @example
    #   search = Twitter::Search.new
    #   search.containing("twitter").fetch
    #   search.clear
    #   search.fetch_next_page #=> 403 Forbidden: You must enter a query.
    def clear
      @cache = nil
      @query = {}
      @query[:q] = []
      self
    end

    # @group Generic filters

    # Search query
    #
    # @param query [String] The search query.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").fetch # Returns an array of tweets containing "twitter"
    #   Twitter::Search.new.contains("twitter").fetch   # Shortcut for the above
    #   Twitter::Search.new.q("twitter").fetch          # Even shorter-cut
    def containing(query)
      @query[:q] << query
      self
    end
    alias :contains :containing
    alias :q :containing

    # Negative search query
    #
    # @param query [String] The negative search query.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("beer").not_containing("root").fetch   # Returns an array of tweets containing "beer" but not "root"
    #   Twitter::Search.new.containing("beer").does_not_contain("root").fetch # Same as above
    #   Twitter::Search.new.containing("beer").excluding("root").fetch        # Shortcut for the above
    #   Twitter::Search.new.contains("beer").excludes("root").fetch           # Even shorter
    #   Twitter::Search.new.q("beer").exclude("root").fetch                   # Shorter still
    def not_containing(query)
      @query[:q] << "-#{query}"
      self
    end
    alias :does_not_contain :not_containing
    alias :excluding :not_containing
    alias :excludes :not_containing
    alias :exclude :not_containing

    # Search for a specific phrase instead of a group of words
    #
    # @param phrase [String] The search phrase.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.phrase("happy hour").fetch # Returns an array of tweets containing the phrase "happy hour"
    def phrase(phrase)
      @query[:phrase] = phrase
      self
    end

    # Only include tweets that contain URLs
    #
    # @param filter [String] A type of search filter. Only 'links' is currently effective.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").filter.fetch # Returns an array of tweets containing "twitter" and URLs
    def filter(filter='links')
      @query[:q] << "filter:#{filter}"
      self
    end

    # Only include tweets from after a given date, specified in the formatted YYYY-MM-DD
    #
    # @param date [String] A date in the format YYYY-MM-DD.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").since_date("2010-10-01").fetch # Return an array of tweets containing "twitter" since October 1, 2010
    def since_date(date)
      @query[:since] = date
      self
    end
    alias :since :since_date

    # Only include tweets from before a given date, specified in the formatted YYYY-MM-DD
    #
    # @param date [String] A date in the format YYYY-MM-DD.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").since_date("2010-10-01").fetch # Return an array of tweets containing "twitter" up until October 1, 2010
    def until_date(date)
      @query[:until] = date
      self
    end
    alias :until :until_date

    # Only include tweets with a positive attitude
    #
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.positive.fetch # Returns an array of tweets containing happy emoticons
    def positive
      @query[:q] << ":)"
      self
    end

    # Only include tweets with a negative attitude
    #
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.negative.fetch # Returns an array of tweets containing sad emoticons
    def negative
      @query[:q] << ":("
      self
    end

    # Only include tweets that are asking a question
    #
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.question.fetch # Returns an array of tweets containing question marks
    def question
      @query[:q] << "?"
      self
    end

    # @group Demographic filters

    # Only include tweets in a given language, specified by an ISO 639-1 code
    #
    # @param code [String] An ISO 639-1 code.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").language("fr").fetch # Returns an array of French-language tweets containing "twitter"
    #   Twitter::Search.new.containing("twitter").lang("fr").fetch     # Shortcut for the above
    # @see http://en.wikipedia.org/wiki/ISO_639-1
    def language(code)
      @query[:lang] = code
      self
    end
    alias :lang :language

    # Specify the language of the query you are sending.
    # This is intended for language-specific clients and
    # the default should work in the majority of cases.
    #
    # @param code [String] An ISO 639-1 code (only 'ja' is currently effective).
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").locale("ja").fetch # Returns an array of tweets from Japan containing "twitter"
    # @see http://en.wikipedia.org/wiki/ISO_639-1
    def locale(code)
      @query[:locale] = code
      self
    end

    # Only include tweets from users in a given radius of a given location, specified by latitude and longitude
    #
    # @param lat [Float] A latitude.
    # @param long [Float] A longitude.
    # @param radius [String] A search radius, specified in either 'mi' (miles) or 'km' (kilometers).
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").geocode(37.781157, -122.398720, "1mi").fetch # Returns an array of tweets within a 1-mile radius of Twitter HQ
    def geocode(lat, long, radius)
      @query[:geocode] = [lat, long, radius].join(",")
      self
    end

    # Only include tweets from users in a given place, specified by a place ID
    #
    # @param place_id [String] A place ID.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.place("5a110d312052166f").fetch # Returns an array of tweets from San Francisco
    def place(place_id)
      @query[:q] << "place:#{place_id}"
      self
    end

    # Only include tweets from users near a given location
    #
    # @param location [String] A location name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.near("San Francisco").fetch # Returns an array of tweets near San Francisco
    def near(location)
      @query[:q] << "near:#{location.inspect}"
      self
    end

    # @group User filters

    # Only include tweets from a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").from("sferik").fetch # Returns an array of tweets containing "twitter" from @sferik
    def from(screen_name)
      @query[:q] << "from:#{screen_name}"
      self
    end

    # Exclude tweets from a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").not_from("sferik").fetch # Returns an array of tweets containing "twitter" from everyone except @sferik
    def not_from(screen_name)
      @query[:q] << "-from:#{screen_name}"
      self
    end

    # Only include tweets to a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").to("sferik").fetch # Returns an array of tweets containing "twitter" to @sferik
    def to(screen_name)
      @query[:q] << "to:#{screen_name}"
      self
    end

    # Exclude tweets to a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").not_to("sferik").fetch # Returns an array of tweets containing "twitter" to everyone except @sferik
    def not_to(screen_name)
      @query[:q] << "-to:#{screen_name}"
      self
    end

    # Only include tweets mentioning a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").mentioning("sferik").fetch # Returns an array of tweets containing "twitter" and mentioning @sferik
    def mentioning(screen_name)
      @query[:q] << "@#{screen_name.gsub('@', '')}"
      self
    end
    alias :referencing :mentioning
    alias :mentions :mentioning
    alias :references :mentioning

    # Exclude tweets mentioning a given user, specified by screen_name
    #
    # @param screen_name [String] A Twitter user name.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").not_mentioning("sferik").fetch # Returns an array of tweets containing "twitter" but not mentioning @sferik
    def not_mentioning(screen_name)
      @query[:q] << "-@#{screen_name.gsub('@', '')}"
      self
    end
    alias :not_referencing :not_mentioning
    alias :does_not_mention :not_mentioning
    alias :does_not_reference :not_mentioning

    # @group Twitter filters

    # Only include retweets
    #
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").retweets.fetch # Returns an array of retweets containing "twitter"
    def retweets
      @query[:q] << "rt"
      self
    end

    # Only include original status updates (i.e., not retweets)
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").no_retweets.fetch # Returns an array of tweets containing "twitter", excluding retweets
    def no_retweets
      @query[:q] << "-rt"
      self
    end

    # Only include tweets containing a given hashtag
    #
    # @param tag [String] A Twitter hashtag.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.hashtag("FollowFriday").fetch # Returns an array of tweets containing the hashtag #FollowFriday
    def hashtag(tag)
      @query[:q] << "\##{tag.gsub('#', '')}"
      self
    end

    # Exclude tweets containing a given hashtag
    #
    # @param tag [String] A Twitter hashtag.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.hashtag("FollowFriday").excluding_hashtag("FF").fetch # Returns an array of tweets containing the hashtag #FollowFriday but not #FF
    #   Twitter::Search.new.hashtag("FollowFriday").excludes_hashtag("FF").fetch  # Shortcut for the above
    #   Twitter::Search.new.hashtag("FollowFriday").exclude_hashtag("FF").fetch   # Even shorter
    def excluding_hashtag(tag)
      @query[:q] << "-\##{tag.gsub('#', '')}"
      self
    end
    alias :excludes_hashtag :excluding_hashtag
    alias :exclude_hashtag :excluding_hashtag

    # Only include tweets with an ID greater than (that is, more recent than) the specified ID.
    #
    # @param id [Integer] A Twitter status ID.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").since_id(123456789).fetch # Returns an array of tweets containing "twitter" with an ID greater than 123456789
    def since_id(id)
      @query[:since_id] = id
      self
    end

    # Only include tweets with an ID less than or equal to the specified ID
    #
    # @param id [Integer] A Twitter status ID.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").max_id(123456789).fetch # Returns an array of tweets containing "twitter" with an ID less than or equal to 123456789
    #
    def max_id(id)
      @query[:max_id] = id
      self
    end
    alias :max :max_id

    # Specify what type of search results you want to receive
    #
    # @param result_type [String] The type of results you want to receive ('recent', 'popular', or 'mixed').
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").result_type("recent").fetch # Returns an array of recent tweets containing "twitter"
    def result_type(result_type="mixed")
      @query[:result_type] = result_type
      self
    end

    # Only include tweets from a given source
    #
    # @param source [String] A Twitter source.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").source("Hibari").fetch # Returns an array of tweets containing "twitter", posted from Hibari
    def source(source)
      @query[:q] << "source:#{source}"
      self
    end

    # @group Paging

    # Specify the number of tweets to return per page
    #
    # @param number [Integer] The number of tweets to return per page, up to a max of 100.
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").per_page(100).fetch # Returns an array of 100 tweets containing "twitter"
    def per_page(number=15)
      @query[:rpp] = number
      self
    end
    alias :rpp :per_page

    # Specify the page number to return, up to a maximum of roughly 1500 results
    #
    # @param number [Integer] The page number (starting at 1) to return, up to a max of roughly 1500 results (based on {Twitter::Client::Search#per_page} * {Twitter::Client::Search#page}).
    # @return [Twitter::Search] self
    # @example
    #   Twitter::Search.new.containing("twitter").page(2).fetch # Returns the second page of tweets containing "twitter"
    def page(number)
      @query[:page] = number
      self
    end

    # Indicates if there are additional results to be fetched
    #
    # @return [Boolean]
    # @example
    #   search = Twitter::Search.new.containing("twitter").fetch
    #   search.next_page? #=> true
    def next_page?
      fetch if @cache.nil?
      !!@cache["next_page"]
    end

    # @group Fetching

    # Fetch the next page of results of the query
    #
    # @return [Array] Tweets that match specified query.
    # @example
    #   search = Twitter::Search.new.containing("twitter").fetch # Returns the first page of results
    #   search.fetch_next_page                                   # Returns the second page of results
    def fetch_next_page
      if next_page?
        @cache = get("search", CGI.parse(@cache["next_page"][1..-1]))
        @cache.results
      end
    end

    # Fetch the results of the query
    #
    # @param force [Boolean] Ignore the cache and hit the API again.
    # @return [Array] Tweets that match specified query.
    # @example
    #   search = Twitter::Search.new.containing("twitter").fetch # Returns an array of tweets containing "twitter"
    def fetch(force=false)
      if @cache.nil? || force
        options = query.dup
        options[:q] = options[:q].join(" ")
        @cache = get("search", options)
      end
      @cache.results
    end

    # Calls block once for each element in self, passing that element as a parameter
    #
    # @yieldparam [Hashie::Mash] result Tweet that matches specified query.
    # @yieldreturn [Array] Tweets that match specified query.
    # @example
    #   Twitter::Search.new.containing('marry me').to('justinbieber').each do |result|
    #     puts "#{result.from_user}: #{result.text}"
    #   end
    def each
      fetch.each{|result| yield result}
    end

  end
end
