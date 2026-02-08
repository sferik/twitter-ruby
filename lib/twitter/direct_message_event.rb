require "twitter/creatable"
require "twitter/entities"
require "twitter/identity"

module Twitter
  # Represents a Twitter direct message event
  class DirectMessageEvent < Identity
    include Creatable
    include Entities

    # The timestamp when the event was created
    #
    # @api public
    # @example
    #   event.created_timestamp
    # @return [String]
    attr_reader :created_timestamp

    object_attr_reader :DirectMessage, :direct_message

    # Initializes a new DirectMessageEvent
    #
    # @api public
    # @example
    #   Twitter::DirectMessageEvent.new(attrs)
    # @param attrs [Hash] The attributes hash from the API response
    # @return [Twitter::DirectMessageEvent]
    def initialize(attrs)
      attrs = read_from_response(attrs)
      text = attrs.dig(:message_create, :message_data, :text)
      urls = attrs.dig(:message_create, :message_data, :entities, :urls)

      text = text.gsub(urls[0][:url], urls[0][:expanded_url]) if urls.any?

      attrs[:direct_message] = build_direct_message(attrs, text)
      super
    end

  private

    # Normalizes the response attributes
    #
    # @api private
    # @param attrs [Hash] The raw attributes hash
    # @return [Hash]
    def read_from_response(attrs)
      attrs[:event].nil? ? attrs : attrs[:event]
    end

    # Builds the direct message hash from event attributes
    #
    # @api private
    # @param attrs [Hash] The event attributes
    # @param text [String] The message text
    # @return [Hash]
    def build_direct_message(attrs, text)
      recipient_id = Integer(attrs.fetch(:message_create).fetch(:target).fetch(:recipient_id))
      sender_id = Integer(attrs.fetch(:message_create).fetch(:sender_id))
      {id: Integer(attrs.fetch(:id)),
       created_at: Time.at(Integer(attrs.fetch(:created_timestamp)) / 1000.0),
       sender: {id: sender_id},
       sender_id:,
       recipient: {id: recipient_id},
       recipient_id:,
       text:}
    end
  end
end
