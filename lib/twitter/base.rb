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

    # Construct an object from a response hash
    #
    # @param response [Hash]
    # @return [Twitter::Base]
    def self.from_response(response={})
      new(response[:body])
    end

    # Create a new object (or NullObject) from attributes
    #
    # @param klass [Class]
    # @param key1 [Symbol]
    # @param key2 [Symbol]
    def self.object_attr_reader(klass, key1, key2=nil)
      define_method key1 do
        ivar = :"@#{key1}"
        return instance_variable_get(ivar) if instance_variable_defined?(ivar)
        object = if @attrs[key1]
          if key2.nil?
            Twitter.const_get(klass).new(@attrs[key1])
          else
            attrs = @attrs.dup
            value = attrs.delete(key1)
            Twitter.const_get(klass).new(value.update(key2 => attrs))
          end
        else
          Twitter::NullObject.new
        end
        instance_variable_set(ivar, object)
      end
      define_method "#{key1}?" do
        !!self.send(key1)
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
