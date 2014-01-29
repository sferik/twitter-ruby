require 'cgi'
require 'twitter/enumerable'
require 'twitter/utils'
require 'uri'

module Twitter
  class SearchResults
    include Twitter::Enumerable
    include Twitter::Utils
    attr_reader :attrs
    alias_method :to_h, :attrs
    deprecate_alias :to_hash, :to_h
    deprecate_alias :to_hsh, :to_h

    # Initializes a new SearchResults object
    #
    # @param attrs [Hash]
    # @param request [Twitter::Request]
    # @return [Twitter::SearchResults]
    def initialize(attrs, request)
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      self.attrs = attrs
    end

  private

    # @return [Boolean]
    def last?
      !next_page?
    end

    # @return [Boolean]
    def next_page?
      !!@attrs[:search_metadata][:next_results] unless @attrs[:search_metadata].nil?
    end

    # Returns a Hash of query parameters for the next result in the search
    #
    # @note Returned Hash can be merged into the previous search options list to easily access the next page.
    # @return [Hash] The parameters needed to fetch the next page.
    def next_page
      if next_page?
        query_string_to_hash(@attrs[:search_metadata][:next_results])
      end
    end

    # @return [Hash]
    def fetch_next_page
      response = @client.send(@request_method, @path, next_page).body
      self.attrs = response
    end

    # @param attrs [Hash]
    # @return [Hash]
    def attrs=(attrs)
      @attrs = attrs
      Array(@attrs[:statuses]).collect do |tweet|
        @collection << Tweet.new(tweet)
      end
      @attrs
    end

    # Converts query string to a hash
    #
    # @param query_string [String] The query string of a URL.
    # @return [Hash] The query string converted to a hash (with symbol keys).
    # @example Convert query string to a hash
    #   query_string_to_hash("foo=bar&baz=qux") #=> {:foo=>"bar", :baz=>"qux"}
    def query_string_to_hash(query_string)
      query = CGI.parse(URI.parse(query_string).query)
      Hash[query.collect { |key, value| [key.to_sym, value.first] }]
    end
  end
end
