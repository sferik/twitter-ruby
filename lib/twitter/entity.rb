require "twitter/base"

module Twitter
  # Represents a Twitter entity with position information
  class Entity < Base
    # The indices of this entity in the text
    #
    # @api public
    # @example
    #   entity.indices
    # @return [Array<Integer>]
    attr_reader :indices
  end
end
