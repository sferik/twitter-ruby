require 'twitter/base'

module Twitter
  class Identifiable < Base

    def self.new(attrs={})
      @@identity_map[self.name] ||= {}
      attrs['id'] && @@identity_map[self.name][attrs['id']] ? @@identity_map[self.name][attrs['id']].update(attrs) : super(attrs)
    end

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      if attrs['id']
        self.update(attrs)
        @@identity_map[self.class.name][attrs['id']] = self
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
