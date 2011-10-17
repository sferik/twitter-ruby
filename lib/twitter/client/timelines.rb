require 'twitter/core_ext/hash'
require 'twitter/status'

module Twitter
  class Client
    # Defines methods related to timelines
    module Timelines

      # Returns the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
      # @note This method can only return up to 800 statuses, including retweets.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets — this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      # @return [Array<Twitter::Status>]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #   Twitter.home_timeline
      def home_timeline(options={})
        get("/1/statuses/home_timeline.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent mentions (statuses containing @username) for the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/mentions
      # @note This method can only return up to 800 statuses. If the :include_rts option is set, only 800 statuses, including retweets if they exist, can be returned.
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_rts The timeline will contain native retweets (if they exist) in addition to the standard stream of tweets when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::Status>]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent mentions (statuses containing @username) for the authenticating user
      #   Twitter.mentions
      def mentions(options={})
        get("/1/statuses/mentions.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent statuses, including retweets if they exist, from non-protected users
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/public_timeline
      # @note The public timeline is cached for 60 seconds. Requesting more frequently than that will not return any more data, and will count against your rate limit usage.
      # @rate_limited Yes
      # @requires_authentication No
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::Status>]
      # @example Return the 20 most recent statuses, including retweets if they exist, from non-protected users
      #   Twitter.public_timeline
      def public_timeline(options={})
        get("/1/statuses/public_timeline.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent retweets posted by the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_by_me
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_by_user
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload retweeted_by(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the 20 most recent retweets posted by the authenticating user
      #     Twitter.retweeted_by("sferik")
      # @overload retweeted_by(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the 20 most recent retweets posted by the authenticating user
      #     Twitter.retweeted_by
      def retweeted_by(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
          get("/1/statuses/retweeted_by_user.json", options)
        else
          get("/1/statuses/retweeted_by_me.json", options)
        end.map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent retweets posted by users the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_to_me
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_to_user
      # @rate_limited Yes
      # @requires_authentication Supported
      # @overload retweeted_to(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
      #     Twitter.retweeted_to
      # @overload retweeted_to(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
      #     Twitter.retweeted_to("sferik")
      def retweeted_to(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
          get("/1/statuses/retweeted_to_user.json", options)
        else
          get("/1/statuses/retweeted_to_me.json", options)
        end.map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent tweets of the authenticated user that have been retweeted by others
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweets_of_me
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Array<Twitter::Status>]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent tweets of the authenticated user that have been retweeted by others
      #   Twitter.retweets_of_me
      def retweets_of_me(options={})
        get("/1/statuses/retweets_of_me.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent statuses posted by the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/user_timeline
      # @note This method can only return up to 3200 statuses. If the :include_rts option is set, only 3200 statuses, including retweets if they exist, can be returned.
      # @rate_limited Yes
      # @requires_authentication No unless the user whose timeline you're trying to view is protected
      # @overload user_timeline(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_rts The timeline will contain native retweets (if they exist) in addition to the standard stream of tweets when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets — this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      #   @return [Array<Twitter::Status>]
      #   @example Return the 20 most recent statuses posted by @sferik
      #     Twitter.user_timeline("sferik")
      def user_timeline(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
        end
        get("/1/statuses/user_timeline.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent images posted by the specified user
      #
      # @see https://support.twitter.com/articles/20169409
      # @note This method can only return up to the 100 most recent images.
      # @note Images will not be returned from tweets posted before January 1, 2010.
      # @rate_limited Yes
      # @requires_authentication No unless the user whose timeline you're trying to view is protected
      # @overload media_timeline(user, options={})
      #   @param user [Integer, String] A Twitter user ID or screen name.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Integer] :page Specifies the page of results to retrieve.
      #   @option options [Boolean] :filter Include possibly sensitive media when set to false, 'f' or 0.
      #   @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      #   @return [Array<Twitter::Status>]
      #   @example Return the 20 most recent statuses posted by @sferik
      #     Twitter.media_timeline("sferik")
      def media_timeline(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        if user = args.pop
          options.merge_user!(user)
        end
        get("/1/statuses/media_timeline.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

      # Returns the 20 most recent statuses from the authenticating user's network
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets — this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      # @return [Array<Twitter::Status>]
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the 20 most recent statuses from the authenticating user's network
      #   Twitter.network_timeline
      def network_timeline(options={})
        get("/i/statuses/network_timeline.json", options).map do |status|
          Twitter::Status.new(status)
        end
      end

    end
  end
end
