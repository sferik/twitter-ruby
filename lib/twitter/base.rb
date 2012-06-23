require 'twitter/identity_map'
require 'twitter/rate_limit'

module Twitter
  class Base
    attr_reader :attrs
    alias body attrs
    alias to_hash attrs

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

    def self.fetch(attrs)
      @@identity_map[self] ||= {}
      @@identity_map[self][Marshal.dump(attrs)]
    end

    def self.from_response(response={})
      self.fetch(response[:body]) || self.new(response[:body], response[:response_headers])
    end

    def self.fetch_or_new(attrs={})
      self.fetch(attrs) || self.new(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @param response_headers [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={}, response_headers={})
      self.update(attrs)
      self.update_rate_limit(response_headers) unless response_headers.empty?
      @@identity_map[self.class] ||= {}
      @@identity_map[self.class][Marshal.dump(attrs)] = self
    end

    # Fetches an attribute of an object using hash notation
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.send(method.to_sym)
    rescue NoMethodError
      nil
    end

    # Update the attributes of an object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
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
