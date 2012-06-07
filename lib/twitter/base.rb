require 'twitter/identity_map'

module Twitter
  class Base
    attr_accessor :attrs
    alias :to_hash :attrs

    @@identity_map = IdentityMap.new

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @overload self.    attr_reader(attr)
    #   @param attr [Symbol]
    # @overload self.    attr_reader(attrs)
    #   @param attrs [Array<Symbol>]
    def self.attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            @attrs[attribute.to_s]
          end
        end
      end
    end

    def self.get(attrs={})
      @@identity_map[self] ||= {}
      @@identity_map[self][Marshal.dump(attrs)]
    end

    def self.get_or_new(attrs={})
      self.get(attrs) || self.new(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      self.update(attrs)
      @@identity_map[self.class] ||= {}
      @@identity_map[self.class][Marshal.dump(attrs)] = self
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.__send__(method.to_sym)
    rescue NoMethodError
      nil
    end

    # Update the attributes of an object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def update(attrs)
      @attrs = attrs
      self
    end

  end
end
