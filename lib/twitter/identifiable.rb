require 'twitter/base'

module Twitter
  class Identifiable < Base

    def self.fetch(attrs)
      id = attrs['id']
      @@identity_map[self] ||= {}
      id && @@identity_map[self][id] && @@identity_map[self][id].update(attrs) || super(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @param response_headers [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={}, response_headers={})
      if attrs['id']
        self.update(attrs)
        self.update_rate_limit(response_headers) unless response_headers.empty?
        @@identity_map[self.class] ||= {}
        @@identity_map[self.class][attrs['id']] = self
      else
        super
      end
    end

    # @param other [Twitter::Identifiable]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Integer]
    def id
      @attrs['id']
    end

  end
end
