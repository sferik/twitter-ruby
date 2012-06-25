require 'twitter/core_ext/kernel'
require 'twitter/rate_limit'

module Twitter
  class Cursor
    attr_reader :attrs, :collection
    alias body attrs
    alias to_hash attrs

    # Initializes a new Cursor object
    #
    # @param response [Hash]
    # @param method [String, Symbol] The name of the method to return the collection
    # @param klass [Class] The class to instantiate object in the collection
    # @return [Twitter::Cursor]
    def self.from_response(response={}, method=:ids, klass=nil)
      self.new(response[:body], method, klass)
    end

    # Initializes a new Cursor
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={}, method=:ids, klass=nil)
      self.update(attrs)
      @collection = Array(attrs[method.to_sym]).map do |item|
        if klass
          klass.fetch_or_new(item)
        else
          item
        end
      end
      class_eval do
        alias_method(method.to_sym, :collection)
      end
    end

    def next_cursor
      @attrs[:next_cursor]
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

    # Update the attributes of an object
    #
    # @param attrs [Hash]
    # @return [Twitter::Cursor]
    def update(attrs)
      @attrs ||= {}
      @attrs.update(attrs)
      self
    end

  end
end
