require 'twitter/arguments'
require 'twitter/error'
require 'twitter/oembed'
require 'twitter/request'
require 'twitter/rest/utils'
require 'twitter/tweet'
require 'twitter/utils'

module Twitter
  module REST
    module Tweets
      include Twitter::REST::Utils
      include Twitter::Utils

      # Returns up to 100 of the first retweets of a given tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>]
      # @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweets(tweet, options = {})
        perform_with_objects(:get, "/1.1/statuses/retweets/#{extract_id(tweet)}.json", options, Twitter::Tweet)
      end

      # Show up to 100 users who retweeted the Tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array]
      # @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean] :ids_only ('false') Only return user ids instead of full user objects.
      def retweeters_of(tweet, options = {})
        ids_only = !!options.delete(:ids_only)
        retweeters = retweets(tweet, options).collect(&:user)
        ids_only ? retweeters.collect(&:id) : retweeters
      end

      # Returns a Tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/show/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @raise [Twitter::Error::Forbidden] Error raised when supplied status is over 140 characters.
      # @return [Twitter::Tweet] The requested Tweet.
      # @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def status(tweet, options = {})
        perform_with_object(:get, "/1.1/statuses/show/#{extract_id(tweet)}.json", options, Twitter::Tweet)
      end

      # Returns Tweets
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/show/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The requested Tweets.
      # @overload statuses(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload statuses(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def statuses(*args)
        parallel_tweets_from_response(:get, '/1.1/statuses/show', args)
      end

      # Destroys the specified Tweets
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/:id
      # @note The authenticating user must be the author of the specified Tweets.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The deleted Tweets.
      # @overload destroy_status(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload destroy_status(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def destroy_status(*args)
        parallel_tweets_from_response(:post, '/1.1/statuses/destroy', args)
      end
      alias_method :destroy_tweet, :destroy_status
      deprecate_alias :status_destroy, :destroy_status
      deprecate_alias :tweet_destroy, :destroy_status

      # Updates the authenticating user's status
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/update
      # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Tweet] The created Tweet.
      # @param status [String] The text of your status update, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @option options [Twitter::Tweet] :in_reply_to_status An existing status that the update is in reply to.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [Twitter::Place] :place A place in the world. These can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def update(status, options = {})
        update!(status, options)
      rescue Twitter::Error::DuplicateStatus
        user_timeline(:count => 1).first
      end

      # Updates the authenticating user's status
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/update
      # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @raise [Twitter::Error::DuplicateStatus] Error raised when a duplicate status is posted.
      # @return [Twitter::Tweet] The created Tweet.
      # @param status [String] The text of your status update, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @option options [Twitter::Tweet] :in_reply_to_status An existing status that the update is in reply to.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [Twitter::Place] :place A place in the world. These can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def update!(status, options = {})
        hash = options.dup
        hash[:in_reply_to_status_id] = hash.delete(:in_reply_to_status).id unless hash[:in_reply_to_status].nil?
        hash[:place_id] = hash.delete(:place).woeid unless hash[:place].nil?
        perform_with_object(:post, '/1.1/statuses/update.json', hash.merge(:status => status), Twitter::Tweet)
      end

      # Retweets the specified Tweets as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The original tweets with retweet details embedded.
      # @overload retweet(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload retweet(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweet(*args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |tweet|
          begin
            post_retweet(extract_id(tweet), arguments.options)
          rescue Twitter::Error::AlreadyRetweeted
            next
          end
        end.compact
      end

      # Retweets the specified Tweets as the authenticating user and raises an error if one has already been retweeted
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::AlreadyRetweeted] Error raised when tweet has already been retweeted.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The original tweets with retweet details embedded.
      # @overload retweet!(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload retweet!(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweet!(*args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |tweet|
          post_retweet(extract_id(tweet), arguments.options)
        end.compact
      end

      # Updates the authenticating user's status with media
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media
      # @note A status update with text/media identical to the authenticating user's current status will NOT be ignored
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Tweet] The created Tweet.
      # @param status [String] The text of your status update, up to 140 characters.
      # @param media [File, Hash] A File object with your picture (PNG, JPEG or GIF)
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :possibly_sensitive Set to true for content which may not be suitable for every audience.
      # @option options [Twitter::Tweet] :in_reply_to_status An existing status that the update is in reply to.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing Tweet that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [Twitter::Place] :place A place in the world. These can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::REST::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def update_with_media(status, media, options = {})
        hash = options.dup
        hash[:in_reply_to_status_id] = hash.delete(:in_reply_to_status).id unless hash[:in_reply_to_status].nil?
        hash[:place_id] = hash.delete(:place).woeid unless hash[:place].nil?
        perform_with_object(:post, '/1.1/statuses/update_with_media.json', hash.merge('media[]' => media, 'status' => status), Twitter::Tweet)
      end

      # Returns oEmbed for a Tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::OEmbed] OEmbed for the requested Tweet.
      # @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      # @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      # @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      # @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      # @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      # @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      # @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      def oembed(tweet, options = {})
        options[:id] = extract_id(tweet)
        perform_with_object(:get, '/1.1/statuses/oembed.json', options, Twitter::OEmbed)
      end

      # Returns oEmbeds for Tweets
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::OEmbed>] OEmbeds for the requested Tweets.
      # @overload oembed(*tweets)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      # @overload oembed(*tweets, options)
      #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      #   @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      #   @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      #   @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      #   @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      #   @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      #   @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      def oembeds(*args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |tweet|
          oembed(extract_id(tweet), arguments.options)
        end
      end

      # Returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter.
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
      # @rate_limited Yes
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload retweeters_ids(options)
      #   @param options [Hash] A customizable set of options.
      # @overload retweeters_ids(id, options = {})
      #   @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
      #   @param options [Hash] A customizable set of options.
      def retweeters_ids(*args)
        arguments = Twitter::Arguments.new(args)
        arguments.options[:id] ||= extract_id(arguments.first)
        perform_with_cursor(:get, '/1.1/statuses/retweeters/ids.json', arguments.options, :ids)
      end

    private

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::Tweet>]
      def parallel_tweets_from_response(request_method, path, args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |tweet|
          perform_with_object(request_method, path + "/#{extract_id(tweet)}.json", arguments.options, Twitter::Tweet)
        end
      end

      def post_retweet(tweet, options)
        response = post("/1.1/statuses/retweet/#{extract_id(tweet)}.json", options).body
        Twitter::Tweet.new(response)
      end
    end
  end
end
