require 'twitter/base'

module Twitter
  class Identifiable < Base

    def self.get(attrs={})
      @@identity_map[self] ||= {}
      attrs['id'] && @@identity_map[self][attrs['id']] && @@identity_map[self][attrs['id']].update(attrs) || super
    end

    def self.get_or_new(attrs={})
      self.get(attrs) || self.new(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      if attrs['id']
        self.update(attrs)
        @@identity_map[self.class] ||= {}
        @@identity_map[self.class][attrs['id']] = self
      else
        super
      end
    end

    # @return [Integer]
    def id
      @attrs['id']
    end

  end
end
