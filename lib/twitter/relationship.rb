require "twitter/base"

module Twitter
  # Represents a relationship between two Twitter users
  class Relationship < Twitter::Base
    object_attr_reader :SourceUser, :source
    object_attr_reader :TargetUser, :target

    # Initializes a new Relationship object
    #
    # @api public
    # @example
    #   Twitter::Relationship.new(relationship: {source: {}, target: {}})
    # @param attrs [Hash] The attributes hash
    # @return [Twitter::Relationship]
    def initialize(attrs = {})
      super
      @attrs = attrs[:relationship] # steep:ignore NoMethod
    end
  end
end
