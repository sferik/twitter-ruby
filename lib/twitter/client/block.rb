require 'twitter/core_ext/hash'
require 'twitter/error/not_found'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to blocking and unblocking users
    # @see Twitter::Client::SpamReporting
    module Block

      # Returns an array of user objects that the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::User>] User objects that the authenticating user is blocking.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return an array of user objects that the authenticating user is blocking
      #   Twitter.blocking
      def blocking(options={})
        get("/1/blocks/blocking.json", options).map do |user|
          Twitter::User.new(user)
        end
      end

      # Returns an array of numeric user ids the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking/ids
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @return [Array] Numeric user ids the authenticating user is blocking.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return an array of numeric user ids the authenticating user is blocking
      #   Twitter.blocking_ids
      def blocked_ids(options={})
        get("/1/blocks/blocking/ids.json", options)
      end

      # Returns true if the authenticating user is blocking a target user
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/exists
      # @requires_authentication Yes
      # @rate_limited Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Check whether the authenticating user is blocking @sferik
      #   Twitter.block?('sferik')
      #   Twitter.block?(7505382)  # Same as above
      def block?(user, options={})
        options.merge_user!(user)
        get("/1/blocks/exists.json", options, :raw => true)
        true
      rescue Twitter::Error::NotFound
        false
      end

      # Blocks the user specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/create
      # @note Destroys a friendship to the blocked user if it exists.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The blocked user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Block and unfriend @sferik as the authenticating user
      #   Twitter.block('sferik')
      #   Twitter.block(7505382)  # Same as above
      def block(user, options={})
        options.merge_user!(user)
        user = post("/1/blocks/create.json", options)
        Twitter::User.new(user)
      end

      # Un-blocks the user specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/destroy
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The un-blocked user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Un-block @sferik as the authenticating user
      #   Twitter.unblock('sferik')
      #   Twitter.unblock(7505382)  # Same as above
      def unblock(user, options={})
        options.merge_user!(user)
        user = delete("/1/blocks/destroy.json", options)
        Twitter::User.new(user)
      end

    end
  end
end
