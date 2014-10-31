require 'twitter/enumerable'
require 'twitter/utils'

module Twitter
  class Cursor
    include Twitter::Enumerable
    include Twitter::Utils
    # @return [Hash]
    attr_reader :attrs
    attr_reader :rate_limit
    alias_method :to_h, :attrs
    alias_method :to_hash, :to_h
    deprecate_alias :to_hsh, :to_hash

    # Initializes a new Cursor
    #
    # @param attrs [Hash]
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param request [Twitter::Request]
    # @param rate_limit [Twitter::RateLimit]
    # @return [Twitter::Cursor]
    def initialize(attrs, key, klass, request, rate_limit = nil) # rubocop:disable ParameterLists
      @key = key.to_sym
      @klass = klass
      @client = request.client
      @request_method = request.verb
      @path = request.path
      @options = request.options
      @rate_limit = rate_limit
      @collection = []
      self.attrs = attrs
    end

    # @return [Twitter::Cursor]
    def each_page(&block)
      loop do
        results = @attrs.fetch(@key, []).map do |element|
          (@klass ? @klass.new(element) : element)
        end

        block.call(results, self)

        break if last?
        fetch_next_page
      end
      self
    end

    # @return [Integer]
    def next_cursor
      @attrs[:next_cursor] || -1
    end
    alias_method :next, :next_cursor

  private

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end

    # @return [Hash]
    def fetch_next_page
      response    = @client.send(@request_method, @path, @options.merge(:cursor => next_cursor))
      @rate_limit = Twitter::RateLimit.new(response.response_headers)
      self.attrs  = response.body
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
