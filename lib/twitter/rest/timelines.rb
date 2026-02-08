require "twitter/rest/utils"
require "twitter/tweet"
require "twitter/user"

module Twitter
  module REST
    # Methods for accessing timelines
    module Timelines
      include Twitter::REST::Utils

      # Default number of tweets per request
      DEFAULT_TWEETS_PER_REQUEST = 20
      # Maximum tweets per request
      MAX_TWEETS_PER_REQUEST = 200

      # Returns the 20 most recent mentions for the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/mentions_timeline
      # @note This method can only return up to 800 Tweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.mentions_timeline
      # @return [Array<Twitter::Tweet>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      def mentions_timeline(options = {})
        perform_get_with_objects("/1.1/statuses/mentions_timeline.json", options, Tweet)
      end
      # @!method mentions
      #   @api public
      #   @see #mentions_timeline
      alias_method :mentions, :mentions_timeline

      # Returns the 20 most recent Tweets posted by the specified user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/user_timeline
      # @note This method can only return up to 3,200 Tweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.user_timeline('sferik')
      # @return [Array<Twitter::Tweet>]
      # @overload user_timeline(user, options = {})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      #   @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
      #   @option options [Boolean, String, Integer] :include_rts Specifies that the timeline should include native retweets in addition to regular tweets. Note: If you're using the trim_user parameter in conjunction with include_rts, the retweets will no longer contain a full user object.
      def user_timeline(*args)
        objects_from_response_with_user(Tweet, :get, "/1.1/statuses/user_timeline.json", args)
      end

      # Returns the 20 most recent retweets posted by the specified user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/user_timeline
      # @note This method can only return up to 3,200 Tweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.retweeted_by_user('sferik')
      # @return [Array<Twitter::Tweet>]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      # @option options [Boolean, String, Integer] :exclude_replies Exclude replies from results.
      # @option options [Boolean, String, Integer] :contributor_details Include contributor screen names.
      def retweeted_by_user(user, options = {})
        retweets_from_timeline(options) do |opts|
          user_timeline(user, opts)
        end
      end
      # @!method retweeted_by
      #   @api public
      #   @see #retweeted_by_user
      alias_method :retweeted_by, :retweeted_by_user

      # Returns the 20 most recent retweets posted by the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/user_timeline
      # @note This method can only return up to 3,200 Tweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.retweeted_by_me
      # @return [Array<Twitter::Tweet>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      # @option options [Boolean, String, Integer] :exclude_replies Exclude replies from results.
      # @option options [Boolean, String, Integer] :contributor_details Include contributor screen names.
      def retweeted_by_me(options = {})
        retweets_from_timeline(options) do |opts|
          user_timeline(opts)
        end
      end

      # Returns the 20 most recent Tweets from the authenticating user's timeline
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/home_timeline
      # @note This method can only return up to 800 Tweets, including retweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.home_timeline
      # @return [Array<Twitter::Tweet>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      # @option options [Boolean, String, Integer] :exclude_replies Exclude replies from results.
      # @option options [Boolean, String, Integer] :include_rts Include native retweets.
      # @option options [Boolean, String, Integer] :contributor_details Include contributor screen names.
      def home_timeline(options = {})
        perform_get_with_objects("/1.1/statuses/home_timeline.json", options, Tweet)
      end

      # Returns the 20 most recent retweets posted by followed users
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/home_timeline
      # @note This method can only return up to 800 Tweets, including retweets.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.retweeted_to_me
      # @return [Array<Twitter::Tweet>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      # @option options [Boolean, String, Integer] :exclude_replies Exclude replies from results.
      # @option options [Boolean, String, Integer] :contributor_details Include contributor screen names.
      def retweeted_to_me(options = {})
        retweets_from_timeline(options) do |opts|
          home_timeline(opts)
        end
      end

      # Returns the 20 most recent tweets that have been retweeted by others
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/statuses/retweets_of_me
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.retweets_of_me
      # @return [Array<Twitter::Tweet>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve.
      # @option options [Integer] :since_id Returns results with an ID greater than the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than the specified ID.
      # @option options [Boolean, String, Integer] :trim_user Include only the author's ID.
      # @option options [Boolean, String, Integer] :include_user_entities Include user entities.
      def retweets_of_me(options = {})
        perform_get_with_objects("/1.1/statuses/retweets_of_me.json", options, Tweet)
      end

      private

      # Retrieves retweets from a timeline
      #
      # @api private
      # @return [Array<Twitter::Tweet>]
      def retweets_from_timeline(options)
        options[:include_rts] = true
        count = options[:count] || DEFAULT_TWEETS_PER_REQUEST
        collect_with_count(count) do |count_options|
          select_retweets(yield(options.merge(count_options)))
        end
      end

      # Selects retweets from a collection of tweets
      #
      # @api private
      # @return [Array<Twitter::Tweet>]
      def select_retweets(tweets)
        tweets.select(&:retweet?)
      end

      # Collects tweets up to a specified count
      #
      # @api private
      # @return [Array<Twitter::Tweet>]
      def collect_with_count(count)
        options = {} # : Hash[Symbol, untyped]
        options[:count] = MAX_TWEETS_PER_REQUEST
        collect_with_max_id do |max_id|
          options[:max_id] = max_id unless max_id.nil?
          if count > 0
            tweets = yield(options)
            count -= tweets.length
            tweets
          end
        end[nil...count]
      end

      # Collects tweets using max_id pagination
      #
      # @api private
      # @return [Array<Twitter::Tweet>]
      def collect_with_max_id(collection = [], max_id = nil, &)
        tweets = yield(max_id)
        return collection if tweets.nil?

        collection += tweets
        tweets.empty? ? collection : collect_with_max_id(collection, tweets.last.id - 1, &) # steep:ignore NoMethod
      end
    end
  end
end
