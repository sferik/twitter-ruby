require 'forwardable'
require 'twitter/memoizable'
require 'twitter/null_object'
require 'uri'

module Twitter
  class Base
    extend Forwardable
    include Twitter::Memoizable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs

    class << self

      # Construct an object from a response hash
      #
      # @param response [Hash]
      # @return [Twitter::Base]
      def from_response(response={})
        new(response[:body])
      end

      # Define methods that retrieve the value from attributes
      #
      # @param attrs [Array, Symbol]
      def attr_reader(*attrs)
        for attr in attrs
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      # Define object methods from attributes
      #
      # @param klass [Symbol]
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def object_attr_reader(klass, key1, key2=nil)
        define_attribute_method(key1, klass, key2)
        define_predicate_method(key1)
      end

      # Define URI methods from attributes
      #
      # @param attrs [Array, Symbol]
      def uri_attr_reader(*attrs)
        for uri_key in attrs
          array = uri_key.to_s.split("_")
          index = array.index("uri")
          array[index] = "url"
          url_key = array.join("_").to_sym
          if uri_key == :display_uri
            define_display_uri_method(uri_key, url_key)
          else
            define_uri_method(uri_key, url_key)
          end
          define_predicate_method(uri_key, url_key)
          alias_method(url_key, uri_key)
          alias_method("#{url_key}?", "#{uri_key}?")
        end
      end

    private

      # Dynamically define a method for a display URI
      #
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def define_display_uri_method(key1, key2)
        define_method(key1) do
            @attrs[key2] if @attrs[key2]
        end
        memoize(key1)
      end

      # Dynamically define a method for a URI
      #
      # @param key1 [Symbol]
      # @param key2 [Symbol]
      def define_uri_method(key1, key2)
        define_method(key1) do
          URI.parse(@attrs[key2]) if @attrs[key2]
        end
        memoize(key1)
      end

      # Dynamically define a method for an attribute
      #
      # @param key1 [Symbol]
      # @param klass [Symbol]
      # @param key2 [Symbol]
      def define_attribute_method(key1, klass=nil, key2=nil)
        define_method(key1) do
          if klass.nil?
            @attrs[key1]
          else
            if @attrs[key1]
              attrs = attrs_for_object(key1, key2)
              Twitter.const_get(klass).new(attrs)
            else
              NullObject.new
            end
          end
        end
        memoize(key1)
      end

      # Dynamically define a predicate method for an attribute
      #
      # @param key [Symbol]
      def define_predicate_method(key1, key2=key1)
        define_method(:"#{key1}?") do
          !!@attrs[key2]
        end
        memoize key1
      end

    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      @attrs = attrs || {}
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end

  private

    def attrs_for_object(key1, key2)
      if key2.nil?
        @attrs[key1]
      else
        attrs = @attrs.dup
        attrs.delete(key1).merge(key2 => attrs)
      end
    end

  end
end
