require 'twitter/core_ext/kernel'

module Twitter
  class Cursor
    include Enumerable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs

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
    def self.from_response(response, key, klass, client, request_method, path, options)
      new(response[:body], key, klass, client, request_method, path, options)
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
    def initialize(attrs, key, klass, client, request_method, path, options)
      @key = key.to_sym
      @klass = klass
      @client = client
      @request_method = request_method.to_sym
      @path = path
      @options = options
      @collection = []
      set_attrs(attrs)
    end

    # @return [Enumerator]
    def each(start = 0, &block)
      return to_enum(:each) unless block_given?
      Array(@collection[start..-1]).each do |element|
        yield element
      end
      unless last?
        start = [@collection.size, start].max
        fetch_next_page
        each(start, &block)
      end
      self
    end

    def next_cursor
      @attrs[:next_cursor] || -1
    end
    alias next next_cursor

    def previous_cursor
      @attrs[:previous_cursor]
    end
    alias previous previous_cursor

    # @return [Boolean]
    def first?
      previous_cursor.zero?
    end

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end

  private

    def fetch_next_page
      response = @client.send(@request_method, @path, @options.merge(:cursor => next_cursor))
      set_attrs(response[:body])
    end

    def set_attrs(attrs)
      @attrs = attrs
      Array(attrs[@key]).each do |element|
        @collection << (@klass ? @klass.new(element) : element)
      end
    end

  end
end
