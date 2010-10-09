module Twitter
  class Search
    include Enumerable
    attr_reader :result, :query

    def initialize(q=nil, options={})
      @adapter = options.delete(:adapter)
      @options = options
      clear
      containing(q) if q && q.strip != ""
      @api_endpoint = "search.twitter.com/search.#{Twitter.format}"
      @api_endpoint = Addressable::URI.heuristic_parse(@api_endpoint)
    end

    def user_agent
      @options[:user_agent] || "Ruby Twitter Gem"
    end

    def from(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}from:#{user}"
      self
    end

    def to(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}to:#{user}"
      self
    end

    def referencing(user, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}@#{user}"
      self
    end
    alias :references :referencing
    alias :ref :referencing

    def containing(word, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}#{word}"
      self
    end
    alias :contains :containing

    def filter(filter)
      @query[:q] << "filter:#{filter}"
      self
    end

    def retweeted
      @query[:q] << "rt"
      self
    end

    def not_retweeted
      @query[:q] << "-rt"
      self
    end

    # adds filtering based on hash tag ie: #twitter
    def hashed(tag, exclude=false)
      @query[:q] << "#{exclude ? "-" : ""}\##{tag}"
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

    def locale(locale)
      @query[:locale] = locale
      self
    end

    # popular|recent
    def result_type(result_type)
      @query[:result_type] = result_type
      self
    end

    # Limits the number of results per page
    def per_page(num)
      @query[:rpp] = num
      self
    end
    alias :rpp :per_page

    # Which page of results to fetch
    def page(num)
      @query[:page] = num
      self
    end

    # Only searches tweets since a given id.
    # Recommended to use this when possible.
    def since_id(id)
      @query[:since_id] = id
      self
    end
    alias :since :since_id

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
      @query[:geocode] = [lat, long, range].join(",")
      self
    end

    def max_id(id)
      @query[:max_id] = id
      self
    end
    alias :max :max_id

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
        query[:q] = query[:q].join(" ")
        perform_get(query)
      end

      @fetch
    end

    def each
      results = fetch['results']
      return if results.nil?
      results.each {|r| yield r}
    end

    def next_page?
      !!fetch["next_page"]
    end

    def fetch_next_page
      if next_page?
        s = Search.new(nil, :user_agent => user_agent)
        s.perform_get(fetch["next_page"][1..-1])
        s
      end
    end

    private

    def connection
      headers = {
        :user_agent => user_agent
      }
      @connection = Faraday::Connection.new(:url => @api_endpoint.omit(:path), :headers => headers) do |builder|
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

    def perform_get(query)
      @fetch = connection.get do |request|
        request.url @api_endpoint.path, query
      end.body
    end

  end
end
