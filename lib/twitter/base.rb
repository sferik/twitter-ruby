require 'forwardable'
require 'twitter/null_object'
require 'uri'

module Twitter
  class Base
    extend Forwardable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs
    def_delegators :attrs, :delete, :update

    # Define methods that retrieve the value from attributes
    #
    # @param attrs [Array, Symbol]
    def self.attr_reader(*attrs)
      attrs.each do |attr|
        define_attribute_method(attr)
        define_predicate_method(attr)
      end
    end

    # Define object methods from attributes
    #
    # @param klass [Symbol]
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    def self.object_attr_reader(klass, key1, key2=nil)
      define_attribute_method(key1, klass, key2)
      define_predicate_method(key1)
    end

    # Define URI methods from attributes
    #
    # @param attrs [Array, Symbol]
    def self.uri_attr_reader(*attrs)
      attrs.each do |uri_key|
        array = uri_key.to_s.split("_")
        index = array.index("uri")
        array[index] = "url"
        url_key = array.join("_").to_sym
        define_uri_method(uri_key, url_key)
        define_predicate_method(uri_key, url_key)
        alias_method(url_key, uri_key)
        alias_method("#{url_key}?", "#{uri_key}?")
      end
    end

    # Dynamically define a method for a URI
    #
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    def self.define_uri_method(key1, key2)
      define_method(key1) do
        memoize(key1) do
          ::URI.parse(@attrs[key2]) if @attrs[key2]
        end
      end
    end

    # Dynamically define a method for an attribute
    #
    # @param key1 [Symbol]
    # @param klass [Symbol]
    # @param key2 [Symbol]
    def self.define_attribute_method(key1, klass=nil, key2=nil)
      define_method(key1) do
        memoize(key1) do
          if klass.nil?
            @attrs[key1]
          else
            if @attrs[key1]
              if key2.nil?
                Twitter.const_get(klass).new(@attrs[key1])
              else
                attrs = @attrs.dup
                value = attrs.delete(key1)
                Twitter.const_get(klass).new(value.update(key2 => attrs))
              end
            else
              Twitter::NullObject.instance
            end
          end
        end
      end
    end

    # Dynamically define a predicate method for an attribute
    #
    # @param key [Symbol]
    def self.define_predicate_method(key1, key2=key1)
      define_method(:"#{key1}?") do
        !!@attrs[key2]
      end
    end

    # Construct an object from a response hash
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def self.from_response(response={})
      new(response[:body])
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

    def memoize(key, &block)
      ivar = :"@#{key}"
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)
      result = block.call
      instance_variable_set(ivar, result)
    end

  private

    # @param attr [Symbol]
    # @param other [Twitter::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr.to_sym).nil? && send(attr.to_sym) == other.send(attr.to_sym)
    end

    # @param other [Twitter::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && attrs == other.attrs
    end

  end
end
