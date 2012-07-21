require 'twitter/api/utils'
require 'twitter/core_ext/hash'

module Twitter
  module API
    module Blocks
      include Twitter::API::Utils

      def self.included(klass)
        klass.class_variable_get(:@@rate_limited).merge!(
          :blocking => true,
          :blocked_ids => true,
          :block? => true,
          :block => true,
          :unblock => false,
        )
      end

      # Returns an array of user objects that the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] User objects that the authenticating user is blocking.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @example Return an array of user objects that the authenticating user is blocking
      #   Twitter.blocking
      def blocking(options={})
        response = get("/1/blocks/blocking.json", options)
        collection_from_array(response[:body], Twitter::User)
      end

      # Returns an array of numeric user ids the authenticating user is blocking
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking/ids
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array] Numeric user ids the authenticating user is blocking.
      # @param options [Hash] A customizable set of options.
      # @example Return an array of numeric user ids the authenticating user is blocking
      #   Twitter.blocking_ids
      def blocked_ids(options={})
        get("/1/blocks/blocking/ids.json", options)[:body]
      end

      # Returns true if the authenticating user is blocking a target user
      #
      # @see https://dev.twitter.com/docs/api/1/get/blocks/exists
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      # @param options [Hash] A customizable set of options.
      # @example Check whether the authenticating user is blocking @sferik
      #   Twitter.block?('sferik')
      #   Twitter.block?(7505382)  # Same as above
      def block?(user, options={})
        options.merge_user!(user)
        get("/1/blocks/exists.json", options)
        true
      rescue Twitter::Error::NotFound
        false
      end

      # Blocks the users specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/create
      # @note Destroys a friendship to the blocked user if it exists.
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The blocked users.
      # @overload block(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Block and unfriend @sferik as the authenticating user
      #     Twitter.block('sferik')
      #     Twitter.block(7505382)  # Same as above
      # @overload block(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def block(*args)
        users_from_response(args) do |options|
          post("/1/blocks/create.json", options)
        end
      end

      # Un-blocks the users specified by the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/blocks/destroy
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The un-blocked users.
      # @overload unblock(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Un-block @sferik as the authenticating user
      #     Twitter.unblock('sferik')
      #     Twitter.unblock(7505382)  # Same as above
      # @overload unblock(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def unblock(*args)
        users_from_response(args) do |options|
          delete("/1/blocks/destroy.json", options)
        end
      end

    end
  end
end

