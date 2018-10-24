require 'twitter/enumerable'
require 'twitter/rest/request'
require 'twitter/utils'

module Twitter
  class Cursor
    include Twitter::Enumerable
    include Twitter::Utils
    # @return [Hash]
    attr_reader :attrs
    alias to_h attrs
    alias to_hash to_h

    # Initializes a new Cursor
    #
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param request [Twitter::REST::Request]
    # @param limit [Integer] After reaching the limit, we stop fetching next page
    # @return [Twitter::Cursor]
    def initialize(key, klass, request, limit = nil)
      @key = key.to_sym
      @klass = klass
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      @limit = limit
      @cursor = @options[:cursor]
      self.attrs = request.perform
    end

    # @return [Integer]
    def next_cursor
      @attrs[:next_cursor]
    end
    alias next next_cursor

  private

    # @return [Boolean]
    def last?
      return false if next_cursor.is_a?(String)
      return true if next_cursor.nil?
      next_cursor.zero?
    end

    # @return [Boolean]
    def reached_limit?
      return false unless @limit
      # Strange bug in Twitter API where if we add the 'cursor' param, they only return 49
      # instead of 50 messages.
      if @cursor
        return @collection.count >= (@limit - 1)
      else
        return @collection.count >= @limit
      end
    end

    # @return [Hash]
    def fetch_next_page
      response = Twitter::REST::Request.new(@client, @request_method, @path, @options.merge(cursor: next_cursor)).perform
      self.attrs = response
    end

    # @param attrs [Hash]
    # @return [Hash]
    def attrs=(attrs)
      @attrs = attrs
      @attrs.fetch(@key, []).each do |element|
        # Don't add more items than we need.
        return @attrs if reached_limit?
        @collection << (@klass ? @klass.new(element) : element)
      end
      @attrs
    end
  end
end
