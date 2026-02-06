require "twitter/entity"

module Twitter
  class Entity
    # Represents a Twitter cashtag symbol entity
    class Symbol < Entity
      # The text of the cashtag without the dollar sign
      #
      # @api public
      # @example
      #   symbol.text
      # @return [String]
      attr_reader :text
    end
  end
end
