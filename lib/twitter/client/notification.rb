module Twitter
  class Client
    # Defines methods related to notification
    module Notification
      # Enables device notifications for updates from the specified user to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/follow
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The specified user.
      # @example Enable device notifications for updates from @sferik
      #   Twitter.enable_notifications("sferik")
      #   Twitter.enable_notifications(7505382)  # Same as above
      def enable_notifications(user, options={})
        merge_user_into_options!(user, options)
        response = post('1/notifications/follow', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Disables notifications for updates from the specified user to the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/notifications/leave
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The specified user.
      # @example Disable device notifications for updates from @sferik
      #   Twitter.disable_notifications("sferik")
      #   Twitter.disable_notifications(7505382)  # Same as above
      def disable_notifications(user, options={})
        merge_user_into_options!(user, options)
        response = post('1/notifications/leave', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
    end
  end
end
