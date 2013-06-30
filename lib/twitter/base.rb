require 'forwardable'
require 'twitter/null_object'

module Twitter
  class Base
    extend Forwardable
    attr_reader :attrs
    alias to_h attrs
    alias to_hash attrs
    alias to_hsh attrs
    def_delegators :attrs, :delete, :update

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @param attrs [Array, Set, Symbol]
    def self.attr_reader(*attrs)
      mod = Module.new do
        attrs.each do |attribute|
          define_method attribute do
            @attrs[attribute.to_sym]
          end
          define_method "#{attribute}?" do
            !!@attrs[attribute.to_sym]
          end
        end
      end
      const_set(:Attributes, mod)
      include mod
    end

    # Construct an object from the response hash
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

    # Create a new object from another object
    #
    # @param klass [Class]
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    def new_without_self(klass, key1, key2)
      if @attrs[key1]
        attrs = @attrs.dup
        value = attrs.delete(key1)
        klass.new(value.update(key2 => attrs))
      else
        Twitter::NullObject.new
      end
    end

    # Create a new object (or NullObject) from attributes
    #
    # @param klass [Class]
    # @param key [Symbol]
    def new_or_null_object(klass, key)
      if @attrs[key]
        klass.new(@attrs[key])
      else
        Twitter::NullObject.new
      end
    end

  private

    # @param attr [Symbol]
    # @param other [Twitter::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr).nil? && send(attr) == other.send(attr)
    end

    # @param other [Twitter::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && attrs == other.attrs
    end

  end
end
