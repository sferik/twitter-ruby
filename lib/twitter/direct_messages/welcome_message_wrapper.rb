require "twitter/creatable"
require "twitter/identity"

module Twitter
  module DirectMessages
    # Wraps a Twitter welcome message response
    class WelcomeMessageWrapper < Twitter::Identity
      # The timestamp when the message was created
      #
      # @api public
      # @example
      #   wrapper.created_timestamp
      # @return [String]
      attr_reader :created_timestamp

      object_attr_reader "DirectMessages::WelcomeMessage", :welcome_message

      # Initializes a new WelcomeMessageWrapper
      #
      # @api public
      # @example
      #   Twitter::DirectMessages::WelcomeMessageWrapper.new(attrs)
      # @param attrs [Hash] The attributes hash from the API response
      # @return [Twitter::DirectMessages::WelcomeMessageWrapper]
      def initialize(attrs)
        attrs = read_from_response(attrs)
        text = attrs.dig(:message_data, :text)
        urls = attrs.dig(:message_data, :entities, :urls)

        text.gsub!(urls[0][:url], urls[0][:expanded_url]) if urls.any?

        attrs[:welcome_message] = build_welcome_message(attrs, text)
        super
      end

    private

      # Normalizes the response attributes
      #
      # @api private
      # @param attrs [Hash] The raw attributes hash
      # @return [Hash]
      def read_from_response(attrs)
        return attrs[:welcome_message] unless attrs[:welcome_message].nil?

        attrs
      end

      # Builds the welcome message hash from attributes
      #
      # @api private
      # @param attrs [Hash] The wrapper attributes
      # @param text [String] The message text
      # @return [Hash]
      def build_welcome_message(attrs, text)
        {
          id: attrs[:id].to_i,
          created_at: Time.at(attrs[:created_timestamp].to_i / 1000.0),
          text:,
          name: attrs[:name],
          entities: attrs.dig(:message_data, :entities),
        }
      end
    end
  end
end
