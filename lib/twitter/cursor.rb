require 'twitter/core_ext/kernel'

module Twitter
  class Cursor
    include Enumerable
    attr_reader :attrs, :collection
    alias to_hash attrs

    # Initializes a new Cursor object
    #
    # @param response [Hash]
    # @param collection_name [String, Symbol] The name of the method to return the collection
    # @param klass [Class] The class to instantiate object in the collection
    # @param client [Twitter::Client]
    # @param method_name [String, Symbol]
    # @param method_options [Hash]
    # @return [Twitter::Cursor]
    def self.from_response(response, collection_name, klass, client, method_name, method_options)
      new(response[:body], collection_name, klass, client, method_name, method_options)
    end

    # Initializes a new Cursor
    #
    # @param attrs [Hash]
    # @param collection_name [String, Symbol] The name of the method to return the collection
    # @param klass [Class] The class to instantiate object in the collection
    # @param client [Twitter::Client]
    # @param method_name [String, Symbol]
    # @param method_options [Hash]
    # @return [Twitter::Cursor]
    def initialize(attrs, collection_name, klass, client, method_name, method_options)
      @attrs = attrs
      @client = client
      @method_name = method_name
      @method_options = method_options
      @collection = Array(attrs[collection_name.to_sym]).map do |item|
        if klass
          klass.fetch_or_new(item)
        else
          item
        end
      end
      singleton_class.class_eval do
        alias_method(collection_name.to_sym, :collection)
      end
    end

    # @param collection [Array]
    # @param cursor [Integer]
    # @return [Array]
    def all(collection=collection, cursor=next_cursor)
      cursor = @client.send(@method_name.to_sym, @method_options.merge(:cursor => cursor))
      collection += cursor.collection
      cursor.last? ? collection.flatten : all(collection, cursor.next_cursor)
    end

    # @return [Enumerable]
    def each
      all(collection, next_cursor).each do |element|
        yield element
      end
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
    alias first first?

    # @return [Boolean]
    def last?
      next_cursor.zero?
    end
    alias last last?

  end
end
