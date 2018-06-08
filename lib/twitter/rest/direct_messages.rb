require 'twitter/arguments'
require 'twitter/direct_message'
require 'twitter/direct_message_event'
require 'twitter/rest/utils'
require 'twitter/user'
require 'twitter/utils'

module Twitter
  module REST
    module DirectMessages
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns the 20 most recent direct messages sent to the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent to the authenticating user.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      def direct_messages_received(options = {})
        perform_get_with_objects('/1.1/direct_messages.json', options, Twitter::DirectMessage)
      end

      # Returns the 20 most recent direct messages events sent to the authenticating user
      # @see https://dev.twitter.com/rest/reference/get/direct_messages/events/list
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessageEvent>] Direct messages sent to and received by the authenticating user.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 50. Default is 20
      # @option options [String] :cursor Specifies the cursor position of results to retrieve.
      def direct_messages_events(options = {})
        perform_get_with_cursor('/1.1/direct_messages/events/list.json', options.merge!(no_default_cursor: true), :events, Twitter::DirectMessageEvent)
      end

      def direct_messages_received(options = {})
        direct_messages_events(options).collection.map(&:direct_message).select{|dm| dm.recipient_id == user_id}
      end

      # Returns the 20 most recent direct messages sent by the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages/sent
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent by the authenticating user.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      def direct_messages_sent(options = {})
        direct_messages_events(options).collection.map(&:direct_message).select{|dm| dm.sender_id == user_id}
      end

      # Returns a direct message
      #
      # @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The requested messages.
      # @param id [Integer] A direct message ID.
      # @param options [Hash] A customizable set of options.

      def direct_message_event(id, options = {})
        options = options.dup
        options[:id] = id
        perform_get_with_object('/1.1/direct_messages/events/show.json', options, Twitter::DirectMessageEvent)
      end

      def direct_message(id, options = {})
        direct_message_event(id, options).direct_message
      end

      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] The requested messages.
      # @overload direct_messages(options = {})
      #   Returns the 20 most recent direct messages sent to the authenticating user
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      # @overload direct_messages(*ids)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      # @overload direct_messages(*ids, options)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/rest/reference/get/direct_messages/show
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      #   @param options [Hash] A customizable set of options.
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
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/delete-message-event
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [nil] Response body from Twitter is nil if successful
      # @overload destroy_direct_message(*ids)
      #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
      def destroy_direct_message(*ids)
        perform_requests(:delete, '/1.1/direct_messages/events/destroy.json', ids)
      end

      # Sends a new direct message to the specified user from the authenticating user
      #
      # @see https://dev.twitter.com/rest/reference/post/direct_messages/new
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The sent message.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @param text [String] The text of your direct message, up to 10,000 characters.
      # @param options [Hash] A customizable set of options.
      def create_direct_message(user, text, options = {})
        options = options.dup
        merge_user!(options, user)
        options[:text] = text
        perform_post_with_object('/1.1/direct_messages/new.json', options, Twitter::DirectMessage)
      end
      alias d create_direct_message
      alias m create_direct_message
      alias dm create_direct_message

      # Create a new direct message event to the specified user from the authenticating user
      #
      # @see https://developer.twitter.com/en/docs/direct-messages/sending-and-receiving/api-reference/new-event
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessageEvent] The created direct message event.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @param text [String] The text of your direct message, up to 10,000 characters.
      # @param options [Hash] A customizable set of options.
      def create_direct_message_event(*args)
        arguments = Twitter::Arguments.new(args)
        options = arguments.options.dup
        if arguments.length >= 2
          options[:event] = {type: 'message_create', message_create: {target: {recipient_id: extract_id(arguments[0])}, message_data: {text: arguments[1]}}}
        end
        response = Twitter::REST::Request.new(self, :json_post, '/1.1/direct_messages/events/new.json', options).perform
        Twitter::DirectMessageEvent.new(response[:event])
      end
    end
  end
end
