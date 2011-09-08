module Twitter
  class Client
    # Defines methods related to URLs
    module Activity
      # Returns activity about me
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array] An array of actions
      # @example Return activity about me
      #   Twitter.about_me
      def about_me(options={})
        get("i/activity/about_me", options, :format => :json, :phoenix => true)
      end

      # Returns activity by friends
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :include_entities Include {http://dev.twitter.com/pages/tweet_entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @return [Array] An array of actions
      # @example Return activity by friends
      #   Twitter.by_friends
      def by_friends(options={})
        get("i/activity/by_friends", options, :format => :json, :phoenix => true)
      end
    end
  end
end
