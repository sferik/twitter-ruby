require "twitter/arguments"
require "twitter/direct_message"
require "twitter/direct_message_event"
require "twitter/rest/upload_utils"
require "twitter/rest/utils"
require "twitter/user"
require "twitter/utils"

module Twitter
  module REST
    # Methods for interacting with direct messages
    module DirectMessages
      include Twitter::REST::UploadUtils
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns all Direct Message events for the authenticated user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/list-events
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_messages_events
      # @param options [Hash] A customizable set of options
      # @option options [Integer] :count Number of records to retrieve (max 50)
      # @option options [String] :cursor Cursor position of results
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Array<Twitter::DirectMessageEvent>] Direct message events
      def direct_messages_events(options = {})
        limit = options.fetch(:count, 20)
        perform_get_with_cursor("/1.1/direct_messages/events/list.json", options.merge!(no_default_cursor: true, count: 50, limit:), :events, Twitter::DirectMessageEvent)
      end

      # Returns all Direct Messages for the authenticated user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/list-events
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_messages_list
      # @param options [Hash] A customizable set of options
      # @option options [Integer] :count Number of records to retrieve (max 50)
      # @option options [String] :cursor Cursor position of results
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Array<Twitter::DirectMessage>] Direct messages
      def direct_messages_list(options = {})
        direct_messages_events(options).collect(&:direct_message)
      end

      # Returns Direct Messages received by the authenticated user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/list-events
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_messages_received
      # @param options [Hash] A customizable set of options
      # @option options [Integer] :count Number of records to retrieve (max 50)
      # @option options [String] :cursor Cursor position of results
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Array<Twitter::DirectMessage>] Direct messages received
      def direct_messages_received(options = {})
        limit = options.fetch(:count, 20)
        direct_messages_list(options).select { |dm| dm.recipient_id == user_id }.first(limit)
      end

      # Returns Direct Messages sent by the authenticated user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/list-events
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_messages_sent
      # @param options [Hash] A customizable set of options
      # @option options [Integer] :count Number of records to retrieve (max 50)
      # @option options [String] :cursor Cursor position of results
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Array<Twitter::DirectMessage>] Direct messages sent
      def direct_messages_sent(options = {})
        limit = options.fetch(:count, 20)
        direct_messages_list(options).select { |dm| dm.sender_id == user_id }.first(limit)
      end

      # Returns a direct message
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/get-event
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_message(123456789)
      # @param id [Integer] A direct message ID
      # @param options [Hash] A customizable set of options
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Twitter::DirectMessage] The requested message
      def direct_message(id, options = {})
        direct_message_event(id, options).direct_message
      end

      # Returns a direct message event
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/get-event
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_message_event(123456789)
      # @param id [Integer] A direct message ID
      # @param options [Hash] A customizable set of options
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Twitter::DirectMessageEvent] The requested message event
      def direct_message_event(id, options = {})
        options = options.dup
        options[:id] = id
        perform_get_with_object("/1.1/direct_messages/events/show.json", options, Twitter::DirectMessageEvent)
      end

      # Returns direct messages
      #
      # @api public
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.direct_messages
      # @overload direct_messages(options = {})
      #   Returns the 20 most recent direct messages sent to the authenticating user
      #   @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/list-events
      #   @param options [Hash] A customizable set of options
      #   @option options [Integer] :count Number of records to retrieve (max 50)
      #   @option options [String] :cursor Cursor position of results
      # @overload direct_messages(*ids)
      #   Returns direct messages
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs
      # @overload direct_messages(*ids, options)
      #   Returns direct messages
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs
      #   @param options [Hash] A customizable set of options
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Array<Twitter::DirectMessage>] The requested messages
      def direct_messages(*args)
        arguments = Twitter::Arguments.new(args)
        if arguments.empty?
          direct_messages_received(arguments.options)
        else
          pmap(arguments) do |id|
            direct_message(id, arguments.options)
          end
        end
      end

      # Destroys direct messages
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/delete-message-event
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.destroy_direct_message(123456789)
      # @overload destroy_direct_message(*ids)
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [nil] Response body from Twitter is nil if successful
      def destroy_direct_message(*ids)
        pmap(ids) do |id|
          perform_requests(:delete, "/1.1/direct_messages/events/destroy.json", id:)
        end
        nil
      end

      # Sends a new direct message to the specified user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/new-event
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.create_direct_message(123456789, "Hello!")
      # @param user_id [Integer] A Twitter user ID
      # @param text [String] The text of the message (up to 10,000 characters)
      # @param options [Hash] A customizable set of options
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Twitter::DirectMessage] The sent message
      def create_direct_message(user_id, text, options = {})
        event = perform_request_with_object(:json_post, "/1.1/direct_messages/events/new.json", format_json_options(user_id, text, options), Twitter::DirectMessageEvent)
        event.direct_message
      end

      # @!method d
      #   @see #create_direct_message
      #   @api public
      #   @example
      #     client.d(123456789, "Hello!")
      #   @return [Twitter::DirectMessage]
      alias d create_direct_message

      # @!method m
      #   @see #create_direct_message
      #   @api public
      #   @example
      #     client.m(123456789, "Hello!")
      #   @return [Twitter::DirectMessage]
      alias m create_direct_message

      # @!method dm
      #   @see #create_direct_message
      #   @api public
      #   @example
      #     client.dm(123456789, "Hello!")
      #   @return [Twitter::DirectMessage]
      alias dm create_direct_message

      # Creates a new direct message event to the specified user
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/new-event
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.create_direct_message_event(123456789, "Hello!")
      # @overload create_direct_message_event(user, text, options = {})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param text [String] The text of the message (up to 10,000 characters).
      #   @param options [Hash] A customizable set of options.
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Twitter::DirectMessageEvent] The created direct message event
      def create_direct_message_event(*args)
        arguments = Twitter::Arguments.new(args)
        options = arguments.options.dup
        options[:event] = {type: "message_create", message_create: {target: {recipient_id: extract_id(arguments[0])}, message_data: {text: arguments[1]}}} if arguments.length >= 2
        response = Twitter::REST::Request.new(self, :json_post, "/1.1/direct_messages/events/new.json", options).perform
        Twitter::DirectMessageEvent.new(response[:event])
      end

      # Creates a direct message event with media attachment
      #
      # @api public
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/new-event
      # @see https://developer.twitter.com/en/docs/direct-messages/message-attachments/guides/attaching-media
      # @note This method requires an access token with RWD permissions
      # @rate_limited Yes
      # @authentication Requires user context
      # @example
      #   client.create_direct_message_event_with_media(123, "Hi!", File.new("image.png"))
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object
      # @param text [String] The text of the message (up to 10,000 characters)
      # @param media [File] A media file (PNG, JPEG, GIF or MP4)
      # @param options [Hash] A customizable set of options
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid
      # @return [Twitter::DirectMessageEvent] The created direct message event
      def create_direct_message_event_with_media(user, text, media, options = {})
        media_id = upload(media, media_category_prefix: "dm")[:media_id]
        options = options.dup
        options[:event] = {type: "message_create", message_create: {target: {recipient_id: extract_id(user)}, message_data: {text:, attachment: {type: "media", media: {id: media_id}}}}}
        response = Twitter::REST::Request.new(self, :json_post, "/1.1/direct_messages/events/new.json", options).perform
        Twitter::DirectMessageEvent.new(response[:event])
      end

    private

      # Formats options for JSON direct message requests
      #
      # @api private
      # @param user_id [Integer] The recipient user ID
      # @param text [String] The message text
      # @param options [Hash] Additional options
      # @return [Hash]
      def format_json_options(user_id, text, options)
        {event: {type: "message_create", message_create: {target: {recipient_id: user_id}, message_data: {text:}.merge(options)}}}
      end
    end
  end
end
