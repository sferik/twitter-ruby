require "twitter/creatable"
require "twitter/entities"
require "twitter/identity"

module Twitter
  # Represents a Twitter direct message
  class DirectMessage < Identity
    include Creatable
    include Entities

    # The text content of the direct message
    #
    # @api public
    # @example
    #   direct_message.text
    # @return [String]
    attr_reader :text

    # The ID of the user who sent this direct message
    #
    # @api public
    # @example
    #   direct_message.sender_id
    # @return [Integer]

    # The ID of the user who received this direct message
    #
    # @api public
    # @example
    #   direct_message.recipient_id
    # @return [Integer]
    attr_reader :sender_id, :recipient_id

    # @!method full_text
    #   The full text content of the direct message
    #   @api public
    #   @example
    #     direct_message.full_text
    #   @return [String]
    alias_method :full_text, :text
    object_attr_reader :User, :recipient
    object_attr_reader :User, :sender
  end
end
