require "twitter/creatable"
require "twitter/entities"
require "twitter/identity"

module Twitter
  # Namespace for direct message related classes
  module DirectMessages
    # Represents a Twitter welcome message for direct messages
    class WelcomeMessage < Twitter::Identity
      include Twitter::Creatable
      include Twitter::Entities

      # The text content of the welcome message
      #
      # @api public
      # @example
      #   welcome_message.text
      # @return [String]
      attr_reader :text

      # The name of the welcome message
      #
      # @api public
      # @example
      #   welcome_message.name
      # @return [String]
      attr_reader :name

      # @!method full_text
      #   The full text content of the welcome message
      #   @api public
      #   @example
      #     welcome_message.full_text
      #   @return [String]
      alias_method :full_text, :text
    end
  end
end
