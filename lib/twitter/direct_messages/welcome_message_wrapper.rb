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
        message_data = attrs.fetch(:message_data)
        text = message_data.fetch(:text)
        urls = message_data.fetch(:entities).fetch(:urls)

        text = text.gsub(urls.fetch(0).fetch(:url), urls.fetch(0).fetch(:expanded_url)) if urls.any?

        attrs[:welcome_message] = build_welcome_message(attrs, text, message_data)
        super
      end

    private

      # Normalizes the response attributes
      #
      # @api private
      # @param attrs [Hash] The raw attributes hash
      # @return [Hash]
      def read_from_response(attrs)
        return attrs.fetch(:welcome_message) unless attrs[:welcome_message].nil?

        attrs
      end

      # Builds the welcome message hash from attributes
      #
      # @api private
      # @param attrs [Hash] The wrapper attributes
      # @param text [String] The message text
      # @return [Hash]
      def build_welcome_message(attrs, text, message_data)
        {
          id: Integer(attrs.fetch(:id)),
          created_at: Time.at(Integer(attrs.fetch(:created_timestamp)) / 1000.0),
          text:,
          name: attrs[:name],
          entities: message_data.fetch(:entities),
        }
      end
    end
  end
end
