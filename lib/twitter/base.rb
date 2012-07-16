module Twitter
  class Base
    attr_reader :attrs
    alias body attrs
    alias to_hash attrs

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
            @attrs[attribute.to_sym]
          end
        end
      end
    end

    # Retrieves an object from the identity map.
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def self.fetch(attrs)
      return unless Twitter.identity_map

      Twitter.identity_map[self] ||= {}
      if object = Twitter.identity_map[self][Marshal.dump(attrs)]
        return object
      end

      return yield if block_given?
      raise Twitter::IdentityMapKeyError, 'key not found'
    end

    # Stores an object in the identity map.
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def self.store(object)
      return object unless Twitter.identity_map

      Twitter.identity_map[self] ||= {}
      Twitter.identity_map[self][Marshal.dump(object.attrs)] = object
    end

    # Returns a new object based on the response hash
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def self.from_response(response={})
      self.fetch_or_new(response[:body])
    end

    # Retrieves an object from the identity map, or stores it in the
    # identity map if it doesn't already exist.
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def self.fetch_or_new(attrs={})
      return self.new(attrs) unless Twitter.identity_map

      self.fetch(attrs) do
        object = self.new(attrs)
        self.store(object)
      end
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      self.update(attrs)
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

  protected

    # @param attr [Symbol]
    # @param other [Twitter::Base]
    # @return [Boolean]
    def attr_equal(attr, other)
      self.class == other.class && !other.send(attr).nil? && self.send(attr) == other.send(attr)
    end

    # @param other [Twitter::Base]
    # @return [Boolean]
    def attrs_equal(other)
      self.class == other.class && !other.attrs.empty? && self.attrs == other.attrs
    end

  end
end
