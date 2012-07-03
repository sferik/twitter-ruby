require 'twitter/base'

module Twitter
  class Identity < Base

    def self.fetch(attrs)
      id = attrs[:id]
      @@identity_map[self] ||= {}
      id && @@identity_map[self][id] && @@identity_map[self][id].update(attrs) || super(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an :id key.
    # @return [Twitter::Base]
    def initialize(attrs={})
      self.update(attrs)
      if self.id
        @@identity_map[self.class] ||= {}
        @@identity_map[self.class][self.id] = self
      else
        raise ArgumentError, "argument must have an :id key"
      end
    end

    # @param other [Twitter::Identity]
    # @return [Boolean]
    def ==(other)
      super || self.attr_equal(:id, other) || self.attrs_equal(other)
    end

    # @return [Integer]
    def id
      @attrs[:id]
    end

  end
end
