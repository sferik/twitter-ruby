require 'twitter/base'

module Twitter
  class Identifiable < Base

    def self.fetch(attrs)
      id = attrs[:id]
      @@identity_map[self] ||= {}
      id && @@identity_map[self][id] && @@identity_map[self][id].update(attrs) || super(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      if attrs[:id]
        self.update(attrs)
        @@identity_map[self.class] ||= {}
        @@identity_map[self.class][attrs[:id]] = self
      else
        super
      end
    end

    # @param other [Twitter::Identifiable]
    # @return [Boolean]
    def ==(other)
      super || self.ids_equal(other) || self.attrs_equal(other)
    end

    # @return [Integer]
    def id
      @attrs[:id]
    end

  protected

    # @param other [Twitter::Identifiable]
    # @return [Boolean]
    def ids_equal(other)
      self.class == other.class && !other.id.nil? && self.id == other.id
    end

  end
end
