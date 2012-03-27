require 'twitter/core_ext/hash'
require 'twitter/direct_message'

module Twitter
  class Client
    # Defines methods related to direct messages
    module DirectMessages

      # Returns the 20 most recent direct messages sent to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/direct_messages
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent to the authenticating user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent direct messages sent to the authenticating user
      #   Twitter.direct_messages
      def direct_messages(options={})
        get("/1/direct_messages.json", options).map do |direct_message|
          Twitter::DirectMessage.new(direct_message)
        end
      end

      # Returns the 20 most recent direct messages sent by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/direct_messages/sent
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::DirectMessage>] Direct messages sent by the authenticating user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent direct messages sent by the authenticating user
      #   Twitter.direct_messages_sent
      def direct_messages_sent(options={})
        get("/1/direct_messages/sent.json", options).map do |direct_message|
          Twitter::DirectMessage.new(direct_message)
        end
      end

      # Destroys a direct message
      #
      # @see https://dev.twitter.com/docs/api/1/post/direct_messages/destroy/:id
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited No
      # @requires_authentication Yes
      # @param id [Integer] The ID of the direct message to delete.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::DirectMessage] The deleted message.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Destroys the direct message with the ID 1825785544
      #   Twitter.direct_message_destroy(1825785544)
      def direct_message_destroy(id, options={})
        direct_message = delete("/1/direct_messages/destroy/#{id}.json", options)
        Twitter::DirectMessage.new(direct_message)
      end

      # Sends a new direct message to the specified user from the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/direct_messages/new
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param text [String] The text of your direct message, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::DirectMessage] The sent message.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Send a direct message to @sferik from the authenticating user
      #   Twitter.direct_message_create('sferik', "I'm sending you this message via @gem!")
      #   Twitter.direct_message_create(7505382, "I'm sending you this message via @gem!")  # Same as above
      def direct_message_create(user, text, options={})
        options.merge_user!(user)
        direct_message = post("/1/direct_messages/new.json", options.merge(:text => text))
        Twitter::DirectMessage.new(direct_message)
      end
      alias :d :direct_message_create

      # Returns a single direct message, specified by id.
      #
      # @see https://dev.twitter.com/docs/api/1/get/direct_messages/show/%3Aid
      # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param id [Integer] The ID of the direct message to retrieve.
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::DirectMessage] The requested message.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the direct message with the id 1825786345
      #   Twitter.direct_message(1825786345)
      def direct_message(id, options={})
        direct_message = get("/1/direct_messages/show/#{id}.json", options)
        Twitter::DirectMessage.new(direct_message)
      end
    end
  end
end
