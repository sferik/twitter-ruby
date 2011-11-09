require 'twitter/action_factory'

module Twitter
  class Client
    # Defines methods related to URLs
    module Activity

      # Returns activity about me
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array] An array of actions
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return activity about me
      #   Twitter.activity_about_me
      def activity_about_me(options={})
        get("/i/activity/about_me.json", options, :phoenix => true).map do |action|
          Twitter::ActionFactory.new(action)
        end
      end

      # Returns activity by friends
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array] An array of actions
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid./
      # @example Return activity by friends
      #   Twitter.activity_by_friends
      def activity_by_friends(options={})
        get("/i/activity/by_friends.json", options, :phoenix => true).map do |action|
          Twitter::ActionFactory.new(action)
        end
      end

    end
  end
end
