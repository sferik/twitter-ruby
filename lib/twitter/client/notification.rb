require 'twitter/core_ext/hash'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to notification
    module Notification

      # Enables device notifications for updates from the specified user to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/follow
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The specified user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Enable device notifications for updates from @sferik
      #   Twitter.enable_notifications("sferik")
      #   Twitter.enable_notifications(7505382)  # Same as above
      def enable_notifications(user, options={})
        options.merge_user!(user)
        user = post("/1/notifications/follow.json", options)
        Twitter::User.new(user)
      end

      # Disables notifications for updates from the specified user to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/leave
      # @rate_limited No
      # @requires_authentication Yes
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Twitter::User] The specified user.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Disable device notifications for updates from @sferik
      #   Twitter.disable_notifications("sferik")
      #   Twitter.disable_notifications(7505382)  # Same as above
      def disable_notifications(user, options={})
        options.merge_user!(user)
        user = post("/1/notifications/leave.json", options)
        Twitter::User.new(user)
      end

    end
  end
end
