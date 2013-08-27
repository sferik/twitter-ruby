require 'twitter/arguments'
require 'twitter/error/already_posted'
require 'twitter/error/already_retweeted'
require 'twitter/error/forbidden'
require 'twitter/oembed'
require 'twitter/rest/api/utils'
require 'twitter/tweet'

module Twitter
  module REST
    module API
      module Tweets
        include Twitter::REST::API::Utils

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
        def retweets(tweet, options={})
          id = extract_id(tweet)
          objects_from_response(Twitter::Tweet, :get, "/1.1/statuses/retweets/#{id}.json", options)
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
        def retweeters_of(tweet, options={})
          ids_only = !!options.delete(:ids_only)
          retweeters = retweets(tweet, options).map(&:user)
          if ids_only
            retweeters.map(&:id)
          else
            retweeters
          end
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
        def status(tweet, options={})
          id = extract_id(tweet)
          object_from_response(Twitter::Tweet, :get, "/1.1/statuses/show/#{id}.json", options)
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
          threaded_tweets_from_response(:get, "/1.1/statuses/show", args)
        end

        # Destroys the specified Tweets
        #
        # @see https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/:id
        # @note The authenticating user must be the author of the specified Tweets.
        # @rate_limited No
        # @authentication Requires user context
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Twitter::Tweet>] The deleted Tweets.
        # @overload status_destroy(*tweets)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        # @overload status_destroy(*tweets, options)
        #   @param tweets [Enumerable<Integer, String, URI, Twitter::Tweet>] A collection of Tweet IDs, URIs, or objects.
        #   @param options [Hash] A customizable set of options.
        #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
        def status_destroy(*args)
          threaded_tweets_from_response(:post, "/1.1/statuses/destroy", args)
        end
        alias tweet_destroy status_destroy

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
        # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
        # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
        # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
        # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::REST::API::PlacesAndGeo#reverse_geocode}.
        # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
        # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
        def update(status, options={})
          object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update.json", options.merge(:status => status))
        rescue Twitter::Error::Forbidden => error
          handle_forbidden_error(Twitter::Error::AlreadyPosted, error)
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
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            begin
              post_retweet(id, arguments.options)
            rescue Twitter::Error::Forbidden => error
              raise unless error.message == Twitter::Error::AlreadyRetweeted::MESSAGE
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
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            begin
              post_retweet(id, arguments.options)
            rescue Twitter::Error::Forbidden => error
              handle_forbidden_error(Twitter::Error::AlreadyRetweeted, error)
            end
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
        # @option options [Integer] :in_reply_to_status_id The ID of an existing Tweet that the update is in reply to.
        # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
        # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
        # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::REST::API::PlacesAndGeo#reverse_geocode}.
        # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
        # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
        def update_with_media(status, media, options={})
          object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update_with_media.json", options.merge('media[]' => media, 'status' => status))
        rescue Twitter::Error::Forbidden => error
          handle_forbidden_error(Twitter::Error::AlreadyPosted, error)
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
        def oembed(tweet, options={})
          options[:id] = extract_id(tweet)
          object_from_response(Twitter::OEmbed, :get, "/1.1/statuses/oembed.json", options)
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
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            oembed(id, arguments.options)
          end
        end

        # Returns a collection of up to 100 user IDs belonging to users who have retweeted the tweet specified by the id parameter.
        #
        # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
        # @rate_limited Yes
        # @authentication Required
        # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
        # @return [Array<Integer>]
        # @overload retweeters_ids(options)
        #   @param options [Hash] A customizable set of options.
        # @overload retweeters_ids(id, options={})
        #   @param tweet [Integer, String, URI, Twitter::Tweet] A Tweet ID, URI, or object.
        #   @param options [Hash] A customizable set of options.
        def retweeters_ids(*args)
          arguments = Twitter::Arguments.new(args)
          arguments.options[:id] ||= extract_id(arguments.first)
          cursor_from_response(:ids, nil, :get, "/1.1/statuses/retweeters/ids.json", arguments.options)
        end

      private

        # @param request_method [Symbol]
        # @param path [String]
        # @param args [Array]
        # @return [Array<Twitter::Tweet>]
        def threaded_tweets_from_response(request_method, path, args)
          arguments = Twitter::Arguments.new(args)
          arguments.flatten.threaded_map do |tweet|
            id = extract_id(tweet)
            object_from_response(Twitter::Tweet, request_method, path + "/#{id}.json", arguments.options)
          end
        end

        def post_retweet(tweet, options)
          id = extract_id(tweet)
          response = post("/1.1/statuses/retweet/#{id}.json", options)
          retweeted_status = response.dup
          retweeted_status[:body] = response[:body].delete(:retweeted_status)
          retweeted_status[:body][:retweeted_status] = response[:body]
          Twitter::Tweet.from_response(retweeted_status)
        end

      end
    end
  end
end
