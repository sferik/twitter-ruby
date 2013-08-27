require 'twitter/arguments'
require 'twitter/direct_message'
require 'twitter/rest/api/utils'
require 'twitter/user'

module Twitter
  module REST
    module API
      module DirectMessages
        include Twitter::REST::API::Utils

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
        # @param id [Integer] A direct message ID.
        # @param options [Hash] A customizable set of options.
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
        # @overload direct_messages(*ids)
        #   Returns direct messages
        #
        #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
        #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
        # @overload direct_messages(*ids, options)
        #   Returns direct messages
        #
        #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
        #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
        #   @param options [Hash] A customizable set of options.
        def direct_messages(*args)
          arguments = Twitter::Arguments.new(args)
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
        #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
        # @overload direct_message_destroy(*ids, options)
        #   @param ids [Enumerable<Integer>] A collection of direct message IDs.
        #   @param options [Hash] A customizable set of options.
        def direct_message_destroy(*args)
          threaded_objects_from_response(Twitter::DirectMessage, :post, "/1.1/direct_messages/destroy.json", args)
        end

        # Sends a new direct message to the specified user from the authenticating user
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/direct_messages/new
        # @rate_limited No
        # @authentication Requires user context
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Twitter::DirectMessage] The sent message.
        # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
        # @param text [String] The text of your direct message, up to 140 characters.
        # @param options [Hash] A customizable set of options.
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
end
