require "cgi"
require "twitter/enumerable"
require "twitter/rest/request"
require "twitter/utils"
require "uri"

module Twitter
  # Represents premium search results from Twitter
  class PremiumSearchResults
    include Enumerable
    include Utils

    # The raw attributes hash
    #
    # @api public
    # @example
    #   results.attrs
    # @return [Hash]
    attr_reader :attrs

    # @!method to_h
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_h
    #   @return [Hash]
    alias_method :to_h, :attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     results.to_hash
    #   @return [Hash]
    alias_method :to_hash, :to_h

    # Initializes a new PremiumSearchResults object
    #
    # @api public
    # @example
    #   Twitter::PremiumSearchResults.new(request)
    # @param request [Twitter::REST::Request] The request object
    # @param request_config [Hash] Configuration options
    # @return [Twitter::PremiumSearchResults]
    def initialize(request, request_config = {})
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @request_config = request_config
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
      !!@attrs[:next]
    end

    # Returns query parameters for the next page
    #
    # @api private
    # @note Returned Hash can be merged into previous search options
    # @return [Hash]
    def next_page
      next_token = @attrs[:next]
      return unless next_token

      {next: next_token}
    end

    # Fetches the next page of results
    #
    # @api private
    # @return [Hash]
    def fetch_next_page
      page = next_page || {}
      next_options = @options.reject { |k| k == :query }.merge(page)
      request = @client.premium_search(@options[:query], next_options, @request_config) # steep:ignore ArgumentTypeMismatch

      self.attrs = request.attrs
    end

    # Sets the attributes and populates the collection
    #
    # @api private
    # @param attrs [Hash] The attributes hash
    # @return [Hash]
    def attrs=(attrs)
      attrs.tap do |value|
        @attrs = value
        value.fetch(:results, []).each do |tweet|
          @collection << Tweet.new(tweet)
        end
      end
    end
  end
end
