require 'twitter/api/utils'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/oembed'
require 'twitter/status'

module Twitter
  module API
    module Statuses
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :favorites => true,
            :favorite => false,
            :fav => false,
            :fave => false,
            :favorite_create => false,
            :unfavorite => false,
            :favorite_destroy => false,
            :home_timeline => true,
            :mentions => true,
            :retweeted_by => true,
            :retweeted_to => true,
            :retweets_of_me => true,
            :user_timeline => true,
            :media_timeline => true,
            :network_timeline => true,
            :retweeters_of => true,
            :retweets => true,
            :status => true,
            :statuses => true,
            :status_activity => true,
            :statuses_activity => true,
            :oembed => true,
            :oembeds => true,
            :status_destroy => false,
            :retweet => true,
            :update => false,
            :update_with_media => false,
          }
        )
      end


      # @see https://dev.twitter.com/docs/api/1/get/favorites
      # @rate_limited Yes
      # @authentication_required No
      # @return [Array<Twitter::Status>] favorite statuses.
      # @overload favorites(options={})
      #   Returns the 20 most recent favorite statuses for the authenticating user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @example Return the 20 most recent favorite statuses for the authenticating user
      #     Twitter.favorites
      # @overload favorites(user, options={})
      #   Returns the 20 most recent favorite statuses for the specified user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @example Return the 20 most recent favorite statuses for @sferik
      #     Twitter.favorites('sferik')
      def favorites(*args)
        options = args.extract_options!
        url = if user = args.pop
          "/1/favorites/#{user}.json"
        else
          "/1/favorites.json"
        end
        collection_from_response(Twitter::Status, :get, url, options)
      end

      # Favorites the specified statuses as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/favorites/create/:id
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The favorited statuses.
      # @overload favorite(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Favorite the status with the ID 25938088801
      #     Twitter.favorite(25938088801)
      # @overload favorite(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      def favorite(*args)
        statuses_from_response(:post, "/1/favorites/create", args)
      end
      alias fav favorite
      alias fave favorite
      alias favorite_create favorite

      # Un-favorites the specified statuses as the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/favorites/destroy/:id
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The un-favorited statuses.
      # @overload unfavorite(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Un-favorite the status with the ID 25938088801
      #     Twitter.unfavorite(25938088801)
      # @overload unfavorite(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      def unfavorite(*args)
        statuses_from_response(:delete, "/1/favorites/destroy", args)
      end
      alias favorite_destroy unfavorite

      # Returns the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
      # @note This method can only return up to 800 statuses, including retweets.
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      # @example Return the 20 most recent statuses, including retweets if they exist, posted by the authenticating user and the users they follow
      #   Twitter.home_timeline
      def home_timeline(options={})
        collection_from_response(Twitter::Status, :get, "/1/statuses/home_timeline.json", options)
      end

      # Returns the 20 most recent mentions (statuses containing @username) for the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/mentions
      # @note This method can only return up to 800 statuses.
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return the 20 most recent mentions (statuses containing @username) for the authenticating user
      #   Twitter.mentions
      def mentions(options={})
        collection_from_response(Twitter::Status, :get, "/1/statuses/mentions.json", options)
      end

      # Returns the 20 most recent retweets posted by the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_by_me
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_by_user
      # @rate_limited Yes
      # @authentication_required Supported
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @overload retweeted_by(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @example Return the 20 most recent retweets posted by the authenticating user
      #     Twitter.retweeted_by('sferik')
      # @overload retweeted_by(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @example Return the 20 most recent retweets posted by the authenticating user
      #     Twitter.retweeted_by
      def retweeted_by(*args)
        options = args.extract_options!
        url = if user = args.pop
          options.merge_user!(user)
          "/1/statuses/retweeted_by_user.json"
        else
          "/1/statuses/retweeted_by_me.json"
        end
        collection_from_response(Twitter::Status, :get, url, options)
      end

      # Returns the 20 most recent retweets posted by users the specified user follows
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_to_me
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweeted_to_user
      # @rate_limited Yes
      # @authentication_required Supported
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @overload retweeted_to(options={})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
      #     Twitter.retweeted_to
      # @overload retweeted_to(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
      #     Twitter.retweeted_to('sferik')
      def retweeted_to(*args)
        options = args.extract_options!
        url = if user = args.pop
          options.merge_user!(user)
          "/1/statuses/retweeted_to_user.json"
        else
          "/1/statuses/retweeted_to_me.json"
        end
        collection_from_response(Twitter::Status, :get, url, options)
      end

      # Returns the 20 most recent tweets of the authenticated user that have been retweeted by others
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweets_of_me
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return the 20 most recent tweets of the authenticated user that have been retweeted by others
      #   Twitter.retweets_of_me
      def retweets_of_me(options={})
        collection_from_response(Twitter::Status, :get, "/1/statuses/retweets_of_me.json", options)
      end

      # Returns the 20 most recent statuses posted by the specified user
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/user_timeline
      # @note This method can only return up to 3200 statuses.
      # @rate_limited Yes
      # @authentication_required No, unless the user whose timeline you're trying to view is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @overload user_timeline(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      #   @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      #   @example Return the 20 most recent statuses posted by @sferik
      #     Twitter.user_timeline('sferik')
      def user_timeline(*args)
        options = args.extract_options!
        if user = args.pop
          options.merge_user!(user)
        end
        collection_from_response(Twitter::Status, :get, "/1/statuses/user_timeline.json", options)
      end

      # Returns the 20 most recent images posted by the specified user
      #
      # @see https://support.twitter.com/articles/20169409
      # @note This method can only return up to the 100 most recent images.
      # @note Images will not be returned from tweets posted before January 1, 2010.
      # @rate_limited Yes
      # @authentication_required No, unless the user whose timeline you're trying to view is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @overload media_timeline(user, options={})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      #   @option options [Boolean] :filter Include possibly sensitive media when set to false, 'f' or 0.
      #   @example Return the 20 most recent statuses posted by @sferik
      #     Twitter.media_timeline('sferik')
      def media_timeline(*args)
        options = args.extract_options!
        if user = args.pop
          options.merge_user!(user)
        end
        collection_from_response(Twitter::Status, :get, "/1/statuses/media_timeline.json", options)
      end

      # Returns the 20 most recent statuses from the authenticating user's network
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
      # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
      # @example Return the 20 most recent statuses from the authenticating user's network
      #   Twitter.network_timeline
      def network_timeline(options={})
        collection_from_response(Twitter::Status, :get, "/i/statuses/network_timeline.json", options)
      end

      # Show up to 100 users who retweeted the status
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by
      # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by/ids
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array]
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @option options [Boolean] :ids_only ('false') Only return user ids instead of full user objects.
      # @example Show up to 100 users who retweeted the status with the ID 28561922516
      #   Twitter.retweeters_of(28561922516)
      def retweeters_of(id, options={})
        if ids_only = !!options.delete(:ids_only)
          get("/1/statuses/#{id}/retweeted_by/ids.json", options)[:body]
        else
          collection_from_response(Twitter::User, :get, "/1/statuses/#{id}/retweeted_by.json", options)
        end
      end

      # Returns up to 100 of the first retweets of a given tweet
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/retweets/:id
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>]
      # @param id [Integer] The numerical ID of the desired status.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return up to 100 of the first retweets of the status with the ID 28561922516
      #   Twitter.retweets(28561922516)
      def retweets(id, options={})
        collection_from_response(Twitter::Status, :get, "/1/statuses/retweets/#{id}.json", options)
      end

      # Returns a status
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/show/:id
      # @rate_limited Yes
      # @authentication_required No, unless the author of the status is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Status] The requested status.
      # @param id [Integer] A Twitter status ID.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Return the status with the ID 25938088801
      #   Twitter.status(25938088801)
      def status(id, options={})
        object_from_response(Twitter::Status, :get, "/1/statuses/show/#{id}.json", options)
      end

      # Returns statuses
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/show/:id
      # @rate_limited Yes
      # @authentication_required No, unless the author of the status is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The requested statuses.
      # @overload statuses(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Return the status with the ID 25938088801
      #     Twitter.statuses(25938088801)
      # @overload statuses(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def statuses(*args)
        statuses_from_response(:get, "/1/statuses/show", args)
      end

      # Returns activity summary for a status
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Status] The requested status.
      # @param id [Integer] A Twitter status ID.
      # @param options [Hash] A customizable set of options.
      # @example Return activity summary for the status with the ID 25938088801
      #   Twitter.status_activity(25938088801)
      def status_activity(id, options={})
        response = get("/i/statuses/#{id}/activity/summary.json", options)
        response[:body].merge!(:id => id) if response[:body]
        Twitter::Status.from_response(response)
      end

      # Returns activity summary for statuses
      #
      # @note Undocumented
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The requested statuses.
      # @overload statuses_activity(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Return activity summary for the status with the ID 25938088801
      #     Twitter.statuses_activity(25938088801)
      # @overload statuses_activity(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      def statuses_activity(*args)
        options = args.extract_options!
        args.flatten.threaded_map do |id|
          status_activity(id, options)
        end
      end

      # Returns oEmbed for status
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication_required No, unless the author of the status is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::OEmbed] OEmbed for the requested status.
      # @param id [Integer, String] A Twitter status ID.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      # @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      # @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      # @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      # @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      # @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      # @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      # @example Return oEmbeds for status with activity summary with the ID 25938088801
      #   Twitter.status_with_activity(25938088801)
      def oembed(id, options={})
        object_from_response(Twitter::OEmbed, :get, "/1/statuses/oembed.json?id=#{id}", options)
      end

      # Returns oEmbeds for statuses
      #
      # @see https://dev.twitter.com/docs/api/1/get/statuses/oembed
      # @rate_limited Yes
      # @authentication_required No, unless the author of the status is protected
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::OEmbed>] OEmbeds for the requested statuses.
      # @overload oembed(*ids_or_urls)
      #   @param ids_or_urls [Array<Integer, String>, Set<Integer, String>] An array of Twitter status IDs or URLs.
      #   @example Return oEmbeds for status with activity summary with the ID 25938088801
      #     Twitter.status_with_activity(25938088801)
      # @overload oembed(*ids_or_urls, options)
      #   @param ids_or_urls [Array<Integer, String>, Set<Integer, String>] An array of Twitter status IDs or URLs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
      #   @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
      #   @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
      #   @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
      #   @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
      #   @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
      #   @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
      def oembeds(*args)
        options = args.extract_options!
        args.flatten.threaded_map do |id|
          object_from_response(Twitter::OEmbed, :get, "/1/statuses/oembed.json?id=#{id}", options)
        end
      end

      # Destroys the specified statuses
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/destroy/:id
      # @note The authenticating user must be the author of the specified status.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The deleted statuses.
      # @overload status_destroy(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Destroy the status with the ID 25938088801
      #     Twitter.status_destroy(25938088801)
      # @overload status_destroy(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def status_destroy(*args)
        statuses_from_response(:delete, "/1/statuses/destroy", args)
      end

      # Retweets tweets
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/retweet/:id
      # @rate_limited Yes
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<Twitter::Status>] The original tweets with retweet details embedded.
      # @overload retweet(*ids)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @example Retweet the status with the ID 28561922516
      #     Twitter.retweet(28561922516)
      # @overload retweet(*ids, options)
      #   @param ids [Array<Integer>, Set<Integer>] An array of Twitter status IDs.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      def retweet(*args)
        options = args.extract_options!
        args.flatten.threaded_map do |id|
          response = post("/1/statuses/retweet/#{id}.json", options)
          retweeted_status = response.dup
          retweeted_status[:body] = response[:body].delete(:retweeted_status)
          retweeted_status[:body][:retweeted_status] = response[:body]
          Twitter::Status.from_response(retweeted_status)
        end
      end

      # Updates the authenticating user's status
      #
      # @see https://dev.twitter.com/docs/api/1/post/statuses/update
      # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Status] The created status.
      # @param status [String] The text of your status update, up to 140 characters.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::API::Geo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Update the authenticating user's status
      #   Twitter.update("I'm tweeting with @gem!")
      def update(status, options={})
        object_from_response(Twitter::Status, :post, "/1/statuses/update.json", options.merge(:status => status))
      end

      # Updates with media the authenticating user's status
      #
      # @see http://dev.twitter.com/docs/api/1/post/statuses/update_with_media
      # @note A status update with text/media identical to the authenticating user's current status will NOT be ignored
      # @rate_limited No
      # @authentication_required Yes
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Status] The created status.
      # @param status [String] The text of your status update, up to 140 characters.
      # @param media [File, Hash] A File object with your picture (PNG, JPEG or GIF)
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
      # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
      # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
      # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::API::Geo#reverse_geocode}.
      # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
      # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
      # @example Update the authenticating user's status
      #   Twitter.update_with_media("I'm tweeting with @gem!", File.new('my_awesome_pic.jpeg'))
      #   Twitter.update_with_media("I'm tweeting with @gem!", {:io => StringIO.new(pic), :type => 'jpg'})
      def update_with_media(status, media, options={})
        object_from_response(Twitter::Status, :post, "/1/statuses/update_with_media.json", options.merge('media[]' => media, 'status' => status), :endpoint => @media_endpoint)
      end

    private

      def statuses_from_response(method, url, args)
        options = args.extract_options!
        args.flatten.threaded_map do |id|
          object_from_response(Twitter::Status, method, url + "/#{id}.json", options)
        end
      end

    end
  end
end
