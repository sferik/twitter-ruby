require 'twitter/api/arguments'
require 'twitter/api/utils'
require 'twitter/error/already_retweeted'
require 'twitter/error/forbidden'
require 'twitter/oembed'
require 'twitter/tweet'

module Twitter
  module API
    module Tweets
      include Twitter::API::Utils

      # Returns up to 100 of the first retweets of a given tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>]
      # @param id [Integer] The numerical ID of the desired Tweet.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return up to 100 of the first retweets of the Tweet with the ID 28561922516
      #   Twitter.retweets(28561922516)
      def retweets(id, options={})
        objects_from_response(Twitter::Tweet, :get, "/1.1/statuses/retweets/#{id}.json", options)
      end

      # Show up to 100 users who retweeted the Tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array]
      # @param id [Integer] The numerical ID of the desired Tweet.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean] :ids_only ('false') Only return user ids instead of full user objects.
      # @example Show up to 100 users who retweeted the Tweet with the ID 28561922516
      #   Twitter.retweeters_of(28561922516)
      def retweeters_of(id, options={})
        ids_only = !!options.delete(:ids_only)
        retweeters = retweets(id, options).map(&:user)
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
      # @return [Twitter::Tweet] The requested Tweet.
      # @param id [Integer] A Tweet ID.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return the Tweet with the ID 25938088801
      #   Twitter.status(25938088801)
      def status(id, options={})
        object_from_response(Twitter::Tweet, :get, "/1.1/statuses/show/#{id}.json", options)
      end

      # Returns Tweets
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/show/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The requested Tweets.
      # @overload statuses(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Return the Tweet with the ID 25938088801
      #     Twitter.statuses(25938088801)
      # @overload statuses(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
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
      # @overload status_destroy(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Destroy the Tweet with the ID 25938088801
      #     Twitter.status_destroy(25938088801)
      # @overload status_destroy(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
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
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::API::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Update the authenticating user's status
      #   Twitter.update("I'm tweeting with @gem!")
      def update(status, options={})
        object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update.json", options.merge(:status => status))
      end

      # Retweets the specified Tweets as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/:id
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Tweet>] The original tweets with retweet details embedded.
      # @overload retweet(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Retweet the Tweet with the ID 28561922516
      #     Twitter.retweet(28561922516)
      # @overload retweet(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweet(*args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id|
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
      # @overload retweet!(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @example Retweet the Tweet with the ID 28561922516
      #     Twitter.retweet!(28561922516)
      # @overload retweet!(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweet!(*args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id|
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
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::API::PlacesAndGeo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Update the authenticating user's status
      #   Twitter.update_with_media("I'm tweeting with @gem!", File.new('my_awesome_pic.jpeg'))
      def update_with_media(status, media, options={})
        object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update_with_media.json", options.merge('media[]' => media, 'status' => status))
      end

      # Returns oEmbed for a Tweet
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::OEmbed] OEmbed for the requested Tweet.
      # @param id_or_url [Integer, String] A Tweet ID or URL.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      # @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      # @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      # @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      # @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      # @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      # @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      # @example Return oEmbeds for Tweet with the ID 25938088801
      #   Twitter.status_with_activity(25938088801)
      def oembed(id_or_url, options={})
        key = id_or_url.is_a?(String) && id_or_url.match(%r{^https?://}i) ? "url" : "id"
        object_from_response(Twitter::OEmbed, :get, "/1.1/statuses/oembed.json?#{key}=#{id_or_url}", options)
      end

      # Returns oEmbeds for Tweets
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::OEmbed>] OEmbeds for the requested Tweets.
      # @overload oembed(*ids_or_urls)
      #   @param ids_or_urls [Array<Integer, String>, Set<Integer, String>] An array of Tweet IDs or URLs.
      #   @example Return oEmbeds for Tweets with the ID 25938088801
      #     Twitter.status_with_activity(25938088801)
      # @overload oembed(*ids_or_urls, options)
      #   @param ids_or_urls [Array<Integer, String>, Set<Integer, String>] An array of Tweet IDs or URLs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      #   @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      #   @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      #   @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      #   @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      #   @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      #   @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      def oembeds(*args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id_or_url|
          oembed(id_or_url, arguments.options)
        end
      end

      # Returns a collection of user IDs belonging to users who have retweeted the specified Tweet.
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
      # @rate_limited Yes
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Integer>]
      # @overload retweeters_ids(options)
      #   @param options [Hash] A customizable set of options.
      #   @example Return a collection of user IDs belonging to users who have retweeted the specified Tweet
      #     Twitter.retweeters_ids({:id => 25938088801})
      # @overload retweeters_ids(id, options={})
      #   @param id [Integer] The numerical ID of the desired Tweet.
      #   @param options [Hash] A customizable set of options.
      #   @example Return a collection of user IDs belonging to users who have retweeted the specified Tweet
      #     Twitter.retweeters_ids(25938088801)
      def retweeters_ids(*args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.options[:id] ||= arguments.first
        cursor_from_response(:ids, nil, :get, "/1.1/statuses/retweeters/ids.json", arguments.options, :retweeters_ids)
      end

    private

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::Tweet>]
      def threaded_tweets_from_response(request_method, path, args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id|
          object_from_response(Twitter::Tweet, request_method, path + "/#{id}.json", arguments.options)
        end
      end

      def post_retweet(id, options)
        response = post("/1.1/statuses/retweet/#{id}.json", options)
        retweeted_status = response.dup
        retweeted_status[:body] = response[:body].delete(:retweeted_status)
        retweeted_status[:body][:retweeted_status] = response[:body]
        Twitter::Tweet.from_response(retweeted_status)
      end

    end
  end
end
