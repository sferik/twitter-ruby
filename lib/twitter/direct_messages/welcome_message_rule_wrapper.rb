require "twitter/creatable"
require "twitter/identity"

module Twitter
  module DirectMessages
    # Wraps a Twitter welcome message rule response
    class WelcomeMessageRuleWrapper < Twitter::Identity
      # The timestamp when the rule was created
      #
      # @api public
      # @example
      #   wrapper.created_timestamp
      # @return [String]
      attr_reader :created_timestamp

      object_attr_reader "DirectMessages::WelcomeMessageRule", :welcome_message_rule

      # Initializes a new WelcomeMessageRuleWrapper
      #
      # @api public
      # @example
      #   Twitter::DirectMessages::WelcomeMessageRuleWrapper.new(attrs)
      # @param attrs [Hash] The attributes hash from the API response
      # @return [Twitter::DirectMessages::WelcomeMessageRuleWrapper]
      def initialize(attrs)
        attrs = read_from_response(attrs)

        attrs[:welcome_message_rule] = build_welcome_message_rule(attrs)
        super
      end

      private

      # Normalizes the response attributes
      #
      # @api private
      # @param attrs [Hash] The raw attributes hash
      # @return [Hash]
      def read_from_response(attrs)
        return attrs[:welcome_message_rule] unless attrs[:welcome_message_rule].nil?

        attrs
      end

      # Builds the welcome message rule hash from attributes
      #
      # @api private
      # @param attrs [Hash] The wrapper attributes
      # @return [Hash]
      def build_welcome_message_rule(attrs)
        {
          id: attrs[:id].to_i,
          created_at: Time.at(attrs[:created_timestamp].to_i / 1000.0),
          welcome_message_id: attrs[:welcome_message_id].to_i
        }
      end
    end
  end
end
