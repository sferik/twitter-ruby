require 'twitter/enumerable'

module Twitter
  class Cursor
    include Twitter::Enumerable
    attr_reader :attrs
    alias_method :to_h, :attrs
    alias_method :to_hash, :attrs
    alias_method :to_hsh, :attrs

    class << self
      # Construct a new Cursor object from a response hash
      #
      # @param response [Hash]
      # @param key [String, Symbol] The key to fetch the data from the response
      # @param klass [Class] The class to instantiate objects in the response
      # @param client [Twitter::REST::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Twitter::Cursor]
      def from_response(response, key, klass, client, request_method, path, options) # rubocop:disable ParameterLists
        new(response[:body], key, klass, client, request_method, path, options)
      end
    end

    # Initializes a new Cursor
    #
    # @param attrs [Hash]
    # @param key [String, Symbol] The key to fetch the data from the response
    # @param klass [Class] The class to instantiate objects in the response
    # @param client [Twitter::REST::Client]
    # @param request_method [String, Symbol]
    # @param path [String]
    # @param options [Hash]
    # @return [Twitter::Cursor]
    def initialize(attrs, key, klass, client, request_method, path, options = {}) # rubocop:disable ParameterLists
      @key = key.to_sym
      @klass = klass
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
      @collection = []
      self.attrs = attrs
    end

  private

    def next_cursor
      @attrs[:next_cursor] || -1
    end
    alias_method :next, :next_cursor

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end

    def fetch_next_page
      response = @client.send(@request_method, @path, @options.merge(:cursor => next_cursor))
      self.attrs = response[:body]
    end

    def attrs=(attrs)
      @attrs = attrs
      Array(attrs[@key]).each do |element|
        @collection << (@klass ? @klass.new(element) : element)
      end
    end
  end
end
