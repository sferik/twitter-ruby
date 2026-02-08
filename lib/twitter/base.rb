require "addressable/uri"
require "forwardable"
require "memoizable"
require "twitter/null_object"
require "twitter/utils"

module Twitter
  # Base class for Twitter objects
  class Base
    extend Forwardable
    include Memoizable
    include Twitter::Utils

    # The raw attributes hash
    #
    # @api public
    # @example
    #   user.attrs # => {id: 123, name: "John"}
    # @return [Hash]
    attr_reader :attrs

    # @!method to_h
    #   Converts the object to a hash
    #   @api public
    #   @example
    #     user.to_h # => {id: 123, name: "John"}
    #   @return [Hash]
    alias_method :to_h, :attrs

    # @!method to_hash
    #   Converts the object to a hash
    #   @api public
    #   @example
    #     user.to_hash # => {id: 123, name: "John"}
    #   @return [Hash]
    alias_method :to_hash, :to_h

    class << self
      # Define methods that retrieve the value from attributes
      #
      # @api private
      # @param attrs [Array, Symbol]
      # @return [void]
      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      # Define predicate methods for attributes
      #
      # @api private
      # @param attrs [Array, Symbol]
      # @return [void]
      def predicate_attr_reader(*attrs)
        attrs.each do |attr|
          define_predicate_method(attr)
        end
      end

      # Define object methods from attributes
      #
      # @api private
      # @param klass [Symbol]
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      # @return [void]
      def object_attr_reader(klass, key1, key2 = nil)
        define_attribute_method(key1, klass, key2)
        define_predicate_method(key1)
      end

      # Define URI methods from attributes
      #
      # @api private
      # @param attrs [Array, Symbol]
      # @return [void]
      def uri_attr_reader(*attrs)
        attrs.each do |uri_key|
          array = uri_key.to_s.split("_")
          index = array.index("uri")
          array[index] = "url"
          url_key = array.join("_").to_sym
          define_uri_method(uri_key, url_key)
          alias_method(url_key, uri_key)
          define_predicate_method(uri_key, url_key)
          alias_method(:"#{url_key}?", :"#{uri_key}?")
        end
      end

      # Define display_uri attribute methods
      #
      # @api private
      # @return [void]
      def display_uri_attr_reader
        define_attribute_method(:display_url)
        alias_method(:display_uri, :display_url)
        define_predicate_method(:display_uri, :display_url)
        alias_method(:display_url?, :display_uri?)
      end

      # Dynamically define a method for a URI
      #
      # @api private
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      # @return [void]
      def define_uri_method(key1, key2)
        define_method(key1) do
          Addressable::URI.parse(@attrs[key2].chomp("#")) unless @attrs[key2].nil? # steep:ignore FallbackAny
        end
        memoize(key1)
      end

      # Dynamically define a method for an attribute
      #
      # @api private
      # @param key1 [Symbol]
      # @param klass [Symbol]
      # @param key2 [Symbol]
      # @return [void]
      def define_attribute_method(key1, klass = nil, key2 = nil)
        define_method(key1) do
          if attr_falsey_or_empty?(key1) # steep:ignore NoMethod
            NullObject.new
          else
            klass.nil? ? @attrs[key1] : Twitter.const_get(klass).new(attrs_for_object(key1, key2)) # steep:ignore NoMethod,FallbackAny
          end
        end
        memoize(key1)
      end

      # Dynamically define a predicate method for an attribute
      #
      # @api private
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      # @return [void]
      def define_predicate_method(key1, key2 = key1)
        define_method(:"#{key1}?") do
          !attr_falsey_or_empty?(key2) # steep:ignore NoMethod
        end
        memoize(:"#{key1}?")
      end
    end

    # Initializes a new object
    #
    # @api public
    # @example
    #   Twitter::Base.new(id: 123, name: "John")
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs = nil)
      @attrs = attrs || {}
    end

    # Fetches an attribute of an object using hash notation
    #
    # @api public
    # @deprecated Use attribute methods instead
    # @example
    #   user[:id] # => 123
    # @param method [String, Symbol] Message to send to the object
    # @return [Object, nil]
    def [](method)
      location = caller_locations(1, 1)&.first
      warn "#{location&.path}:#{location&.lineno}: [DEPRECATION] #[#{method.inspect}] is deprecated. Use ##{method} to fetch the value."
      public_send(method.to_sym)
    rescue NoMethodError
      nil
    end

    private

    # Check if an attribute is falsey or empty
    #
    # @api private
    # @param key [Symbol]
    # @return [Boolean]
    def attr_falsey_or_empty?(key)
      !@attrs[key] || (@attrs[key].respond_to?(:empty?) && @attrs[key].empty?)
    end

    # Get attributes for creating a nested object
    #
    # @api private
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    # @return [Hash]
    def attrs_for_object(key1, key2 = nil)
      if key2.nil?
        @attrs[key1]
      else
        attrs = @attrs.dup
        attrs.delete(key1).merge(key2 => attrs)
      end
    end
  end
end
