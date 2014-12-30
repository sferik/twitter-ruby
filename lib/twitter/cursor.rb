require 'twitter/enumerable'
require 'twitter/rest/request'
require 'twitter/utils'

module Twitter
  class Cursor
    include Twitter::Enumerable
    include Twitter::Utils
    # @return [Hash]
    attr_reader :attrs
    alias_method :to_h, :attrs
    alias_method :to_hash, :to_h

    # Initializes a new Cursor
    #
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param request [Twitter::REST::Request]
    # @return [Twitter::Cursor]
    def initialize(key, klass, request)
      @key = key.to_sym
      @klass = klass
      @request = request
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @collection = []
      self.attrs = request.perform
    end

    # @yield [Enumerator, Twitter::Cursor]
    def each_page_with_cursor(start = 0)
      return to_enum(:each_page_with_cursor, start) unless block_given?
      each_page(start).each { |page| yield([page, self]) }
    end

    # @return [Twitter::RateLimit] The rate limit for the current cursor request
    def rate_limit
      @request.rate_limit
    end

  private

    # @return [Integer]
    def next_cursor
      @attrs[:next_cursor] || -1
    end
    alias_method :next, :next_cursor

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end

    # @return [Hash]
    def fetch_next_page
      @request = Twitter::REST::Request.new(@client, @request_method, @path, @options.merge(cursor: next_cursor))
      self.attrs = @request.perform
    end

    # @param attrs [Hash]
    # @return [Hash]
    def attrs=(attrs)
      @attrs = attrs
      @attrs.fetch(@key, []).each do |element|
        @collection << (@klass ? @klass.new(element) : element)
      end
      @attrs
    end
  end
end
