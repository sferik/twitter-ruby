require "twitter/enumerable"
require "twitter/rest/request"
require "twitter/utils"

module Twitter
  # Represents a cursor for paginating through Twitter API responses
  class Cursor
    include Enumerable
    include Utils

    # The raw response attributes
    #
    # @api public
    # @example
    #   cursor.attrs # => {users: [...], next_cursor: 123}
    # @return [Hash]
    attr_reader :attrs

    # @!method to_h
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     cursor.to_h # => {users: [...], next_cursor: 123}
    #   @return [Hash]
    alias to_h attrs

    # @!method to_hash
    #   Returns the attributes as a hash
    #   @api public
    #   @example
    #     cursor.to_hash # => {users: [...], next_cursor: 123}
    #   @return [Hash]
    alias to_hash to_h

    # Initializes a new Cursor
    #
    # @api public
    # @example
    #   cursor = Twitter::Cursor.new(:users, Twitter::User, request)
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param request [Twitter::REST::Request]
    # @param limit [Integer] After reaching the limit, we stop fetching next page
    # @return [Twitter::Cursor]
    def initialize(key, klass, request, limit = nil)
      @key = key
      @klass = klass
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      @limit = limit
      self.attrs = request.perform
    end

  private

    # The next cursor value for pagination
    #
    # @api private
    # @return [Integer]
    def next_cursor
      @attrs[:next_cursor]
    end

    # @!method next
    #   The next cursor value for pagination
    #   @api private
    #   @return [Integer]
    alias next next_cursor

    # Check if this is the last page of results
    #
    # @api private
    # @return [Boolean]
    def last?
      return false if next_cursor.is_a?(String)
      return true if next_cursor.nil?

      next_cursor.zero?
    end

    # Check if the limit has been reached
    #
    # @api private
    # @return [Boolean]
    def reached_limit?
      limit = @limit
      return false if limit.nil?

      limit <= attrs[@key].count
    end

    # Fetch the next page of results
    #
    # @api private
    # @return [Hash]
    def fetch_next_page
      response = REST::Request.new(@client, @request_method, @path, @options.merge(cursor: next_cursor)).perform
      self.attrs = response
    end

    # Set the attributes and populate the collection
    #
    # @api private
    # @param attrs [Hash]
    # @return [Hash]
    def attrs=(attrs)
      @attrs = attrs
      klass = @klass
      @attrs.fetch(@key, []).each do |element|
        @collection << (klass ? klass.new(element) : element) # steep:ignore UnexpectedPositionalArgument
      end
    end
  end
end
