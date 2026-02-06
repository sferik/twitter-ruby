require "twitter/entity"

module Twitter
  class Entity
    # Represents a Twitter hashtag entity
    class Hashtag < Entity
      # The text of the hashtag without the hash symbol
      #
      # @api public
      # @example
      #   hashtag.text
      # @return [String]
      attr_reader :text
    end
  end
end
