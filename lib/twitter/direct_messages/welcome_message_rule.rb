require "twitter/creatable"
require "twitter/identity"

module Twitter
  module DirectMessages
    # Represents a Twitter welcome message rule
    class WelcomeMessageRule < Twitter::Identity
      include Twitter::Creatable

      # The ID of the associated welcome message
      #
      # @api public
      # @example
      #   rule.welcome_message_id
      # @return [Integer]
      attr_reader :welcome_message_id
    end
  end
end
