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
    # @params method [String, Symbol] The name of the method to return the collection
    # @params klass [Class] The class to instantiate object in the collection
    # @return [Twitter::Cursor]
    def self.from_response(response={}, method='ids', klass=nil)
      self.new(response[:body], response[:response_headers], method, klass)
    end

    # Initializes a new Cursor
    #
    # @param attrs [Hash]
    # @param response_headers [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={}, response_headers={}, method='ids', klass=nil)
      self.update(attrs)
      self.update_rate_limit(response_headers) unless response_headers.empty?
      @collection = Array(attrs[method.to_s]).map do |item|
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
      @attrs['next_cursor']
    end
    alias next next_cursor

    def previous_cursor
      @attrs['previous_cursor']
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
    # @param response [Hash]
    # @return [Twitter::Cursor]
    def update(attrs)
      @attrs ||= {}
      @attrs.update(attrs)
      self
    end

    # Update the RateLimit object
    #
    # @param response_headers [Hash]
    # @return [Twitter::RateLimit]
    def update_rate_limit(response_headers)
      Twitter::RateLimit.instance.update(response_headers)
    end

  end
end
