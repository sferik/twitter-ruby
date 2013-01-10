require 'twitter/api/arguments'
require 'twitter/api/utils'
require 'twitter/direct_message'
require 'twitter/user'

module Twitter
  module API
    module DirectMessages
      include Twitter::API::Utils

      # Returns the 20 most recent direct messages sent to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages
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
      # @example Return the 20 most recent direct messages sent to the authenticating user
      #   Twitter.direct_messages_received
      def direct_messages_received(options={})
        objects_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages.json", options)
      end

      # Returns the 20 most recent direct messages sent by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/sent
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
      # @example Return the 20 most recent direct messages sent by the authenticating user
      #   Twitter.direct_messages_sent
      def direct_messages_sent(options={})
        objects_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages/sent.json", options)
      end

      # Returns a direct message
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The requested messages.
      # @param id [Integer] A Tweet IDs.
      # @param options [Hash] A customizable set of options.
      # @example Return the direct message with the id 1825786345
      #   Twitter.direct_message(1825786345)
      def direct_message(id, options={})
        options[:id] = id
        object_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages/show.json", options)
      end

      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] The requested messages.
      # @overload direct_messages(options={})
      #   Returns the 20 most recent direct messages sent to the authenticating user
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @example Return the 20 most recent direct messages sent to the authenticating user
      #     Twitter.direct_messages
      # @overload direct_messages(*ids)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Return the direct message with the id 1825786345
      #     Twitter.direct_messages(1825786345)
      # @overload direct_messages(*ids, options)
      #   Returns direct messages
      #
      #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      def direct_messages(*args)
        arguments = Twitter::API::Arguments.new(args)
        if arguments.empty?
          direct_messages_received(arguments.options)
        else
          arguments.flatten.threaded_map do |id|
            direct_message(id, arguments.options)
          end
        end
      end

      # Destroys direct messages
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/direct_messages/destroy
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::DirectMessage>] Deleted direct message.
      # @overload direct_message_destroy(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Destroys the direct message with the ID 1825785544
      #     Twitter.direct_message_destroy(1825785544)
      # @overload direct_message_destroy(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      def direct_message_destroy(*args)
        threaded_object_from_response(Twitter::DirectMessage, :post, "/1.1/direct_messages/destroy.json", args)
      end

      # Sends a new direct message to the specified user from the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/direct_messages/new
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::DirectMessage] The sent message.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      # @param text [String] The text of your direct message, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @example Send a direct message to @sferik from the authenticating user
      #   Twitter.direct_message_create('sferik', "I'm sending you this message via @gem!")
      #   Twitter.direct_message_create(7505382, "I'm sending you this message via @gem!")  # Same as above
      def direct_message_create(user, text, options={})
        merge_user!(options, user)
        options[:text] = text
        object_from_response(Twitter::DirectMessage, :post, "/1.1/direct_messages/new.json", options)
      end
      alias d direct_message_create
      alias m direct_message_create

    end
  end
end
