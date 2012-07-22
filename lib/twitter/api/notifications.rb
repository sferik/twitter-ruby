require 'twitter/api/utils'

module Twitter
  module API
    module Notifications
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :enable_notifications => false,
            :disable_notifications => false,
          }
        )
      end

      # Enables device notifications for updates from the specified users to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/follow
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The specified users.
      # @overload enable_notifications(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Enable device notifications for updates from @sferik
      #     Twitter.enable_notifications('sferik')
      #     Twitter.enable_notifications(7505382)  # Same as above
      # @overload enable_notifications(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def enable_notifications(*args)
        users_from_response("/1/notifications/follow.json", args)
      end

      # Disables notifications for updates from the specified users to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/leave
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::User>] The specified users.
      # @overload disable_notifications(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Disable device notifications for updates from @sferik
      #     Twitter.disable_notifications('sferik')
      #     Twitter.disable_notifications(7505382)  # Same as above
      # @overload disable_notifications(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def disable_notifications(*args)
        users_from_response("/1/notifications/leave.json", args)
      end

    end
  end
end
