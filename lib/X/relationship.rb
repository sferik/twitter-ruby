require "X/base"

module X
  class Relationship < X::Base
    object_attr_reader :SourceUser, :source
    object_attr_reader :TargetUser, :target

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [X::Relationship]
    def initialize(attrs = {})
      super
      @attrs = attrs[:relationship]
    end
  end
end
