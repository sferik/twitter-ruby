require "cgi"
require "twitter/enumerable"
require "twitter/rest/request"
require "twitter/utils"
require "uri"

module Twitter
  # Represents search results from Twitter
  class SearchResults
    include Twitter::Enumerable
    include Twitter::Utils

    # The raw attributes hash
    #
    # @api public
    # @example
    #   results.attrs
    # @return [Hash]

    # The rate limit information from the response
    #
    # @api public
    # @example
    #   results.rate_limit
    # @return [Twitter::RateLimit]
    attr_reader :attrs, :rate_limit

    # @!method to_h
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_h
    #   @return [Hash]
    alias to_h attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_hash
    #   @return [Hash]
    alias to_hash to_h

    # Initializes a new SearchResults object
    #
    # @api public
    # @example
    #   Twitter::SearchResults.new(request)
    # @param request [Twitter::REST::Request] The request object
    # @return [Twitter::SearchResults]
    def initialize(request)
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      self.attrs = request.perform
    end

  private

    # Returns true if this is the last page of results
    #
    # @api private
    # @return [Boolean]
    def last?
      !next_page?
    end

    # Returns true if there is a next page
    #
    # @api private
    # @return [Boolean]
    def next_page?
      !!@attrs[:search_metadata][:next_results] unless @attrs[:search_metadata].nil?
    end

    # Returns query parameters for the next page
    #
    # @api private
    # @note Returned Hash can be merged into previous search options
    # @return [Hash]
    def next_page
      query_string_to_hash(@attrs[:search_metadata][:next_results]) if next_page?
    end

    # Fetches the next page of results
    #
    # @api private
    # @return [Hash]
    def fetch_next_page
      response = Twitter::REST::Request.new(@client, @request_method, @path, @options.merge(next_page))
      self.attrs = response.perform
      @rate_limit = response.rate_limit
    end

    # Sets the attributes and populates the collection
    #
    # @api private
    # @param attrs [Hash] The attributes hash
    # @return [Hash]
    def attrs=(attrs)
      @attrs = attrs
      @attrs.fetch(:statuses, []).collect do |tweet|
        @collection << Tweet.new(tweet)
      end
      @attrs
    end

    # Converts query string to a hash
    #
    # @api private
    # @param query_string [String] The query string of a URL
    # @return [Hash]
    def query_string_to_hash(query_string)
      query = CGI.parse(URI.parse(query_string).query)
      query.to_h { |key, value| [key.to_sym, value.first] }
    end
  end
end
