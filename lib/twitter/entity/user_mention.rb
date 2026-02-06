require "twitter/entity"

module Twitter
  class Entity
    # Represents a Twitter user mention entity
    class UserMention < Twitter::Entity
      # The ID of the mentioned user
      #
      # @api public
      # @example
      #   user_mention.id
      # @return [Integer]
      attr_reader :id

      # The display name of the mentioned user
      #
      # @api public
      # @example
      #   user_mention.name
      # @return [String]

      # The screen name of the mentioned user
      #
      # @api public
      # @example
      #   user_mention.screen_name
      # @return [String]
      attr_reader :name, :screen_name
    end
  end
end
