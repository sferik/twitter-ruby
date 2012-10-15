require 'twitter/action_factory'
require 'twitter/configuration'
require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/core_ext/kernel'
require 'twitter/cursor'
require 'twitter/direct_message'
require 'twitter/error/forbidden'
require 'twitter/error/not_found'
require 'twitter/language'
require 'twitter/list'
require 'twitter/oembed'
require 'twitter/place'
require 'twitter/relationship'
require 'twitter/saved_search'
require 'twitter/search_results'
require 'twitter/settings'
require 'twitter/suggestion'
require 'twitter/trend'
require 'twitter/tweet'
require 'twitter/user'

module Twitter
  module API
    DEFAULT_CURSOR = -1
    DEFAULT_TWEETS_PER_REQUEST = 20
    MAX_USERS_PER_REQUEST = 100
    MAX_TWEETS_PER_REQUEST = 200

    # Returns the requesting user if authentication was successful, otherwise raises {Twitter::Error::Unauthorized}
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets when set to true, 't' or 1.
    # @example Return the requesting user if authentication was successful
    #   Twitter.verify_credentials
    def verify_credentials(options={})
      object_from_response(Twitter::User, :get, "/1.1/account/verify_credentials.json", options)
    end
    alias current_user verify_credentials

    # Sets which device Twitter delivers updates to for the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_delivery_device
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param device [String] Must be one of: 'sms', 'none'.
    # @param options [Hash] A customizable set of options.
    # @example Turn SMS updates on for the authenticating user
    #   Twitter.update_delivery_device('sms')
    def update_delivery_device(device, options={})
      object_from_response(Twitter::User, :post, "/1.1/account/update_delivery_device.json", options.merge(:device => device))
    end

    # Sets values that users are able to set under the "Account" tab of their settings page
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_profile
    # @note Only the options specified will be updated.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :name Full name associated with the profile. Maximum of 20 characters.
    # @option options [String] :url URL associated with the profile. Will be prepended with "http://" if not present. Maximum of 100 characters.
    # @option options [String] :location The city or country describing where the user of the account is located. The contents are not normalized or geocoded in any way. Maximum of 30 characters.
    # @option options [String] :description A description of the user owning the account. Maximum of 160 characters.
    # @example Set authenticating user's name to Erik Michaels-Ober
    #   Twitter.update_profile(:name => "Erik Michaels-Ober")
    def update_profile(options={})
      object_from_response(Twitter::User, :post, "/1.1/account/update_profile.json", options)
    end

    # Updates the authenticating user's profile background image
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_profile_background_image
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param image [File] The background image for the profile, base64-encoded. Must be a valid GIF, JPG, or PNG image of less than 800 kilobytes in size. Images with width larger than 2048 pixels will be forcibly scaled down. The image must be provided as raw multipart data, not a URL.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :tile Whether or not to tile the background image. If set to true the background image will be displayed tiled. The image will not be tiled otherwise.
    # @example Update the authenticating user's profile background image
    #   Twitter.update_profile_background_image(File.new("we_concept_bg2.png"))
    def update_profile_background_image(image, options={})
      object_from_response(Twitter::User, :post, "/1.1/account/update_profile_background_image.json", options.merge(:image => image))
    end

    # Sets one or more hex values that control the color scheme of the authenticating user's profile
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_profile_colors
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :profile_background_color Profile background color.
    # @option options [String] :profile_text_color Profile text color.
    # @option options [String] :profile_link_color Profile link color.
    # @option options [String] :profile_sidebar_fill_color Profile sidebar's background color.
    # @option options [String] :profile_sidebar_border_color Profile sidebar's border color.
    # @example Set authenticating user's profile background to black
    #   Twitter.update_profile_colors(:profile_background_color => '000000')
    def update_profile_colors(options={})
      object_from_response(Twitter::User, :post, "/1.1/account/update_profile_colors.json", options)
    end

    # Updates the authenticating user's profile image
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_profile_image
    # @note Updates the authenticating user's profile image. Note that this method expects raw multipart data, not a URL to an image.
    # @note This method asynchronously processes the uploaded file before updating the user's profile image URL. You can either update your local cache the next time you request the user's information, or, at least 5 seconds after uploading the image, ask for the updated URL using GET users/show.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The authenticated user.
    # @param image [File] The avatar image for the profile, base64-encoded. Must be a valid GIF, JPG, or PNG image of less than 700 kilobytes in size. Images with width larger than 500 pixels will be scaled down. Animated GIFs will be converted to a static GIF of the first frame, removing the animation.
    # @param options [Hash] A customizable set of options.
    # @example Update the authenticating user's profile image
    #   Twitter.update_profile_image(File.new("me.jpeg"))
    def update_profile_image(image, options={})
      object_from_response(Twitter::User, :post, "/1.1/account/update_profile_image.json", options.merge(:image => image))
    end

    # Updates the authenticating user's profile banner image
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/update_profile_banner
    # @note Uploads a profile banner on behalf of the authenticating user. For best results, upload an <5MB image that is exactly 1252px by 626px. Images will be resized for a number of display options. Users with an uploaded profile banner will have a profile_banner_url node in their Users objects. More information about sizing variations can be found in User Profile Images and Banners.
    # @note Profile banner images are processed asynchronously. The profile_banner_url and its variant sizes will not necessary be available directly after upload.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::BadRequest] Error raised when either an image was not provided or the image data could not be processed.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @raise [Twitter::Error::UnprocessableEntity] Error raised when the image could not be resized or is too large.
    # @return [nil]
    # @param image [File] The Base64-encoded or raw image data being uploaded as the user's new profile banner.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :width The width of the preferred section of the image being uploaded in pixels. Use with height, offset_left, and offset_top to select the desired region of the image to use.
    # @option options [Integer] :height The height of the preferred section of the image being uploaded in pixels. Use with width, offset_left, and offset_top to select the desired region of the image to use.
    # @option options [Integer] :offset_left The number of pixels by which to offset the uploaded image from the left. Use with height, width, and offset_top to select the desired region of the image to use.
    # @option options [Integer] :offset_top The number of pixels by which to offset the uploaded image from the top. Use with height, width, and offset_left to select the desired region of the image to use.
    # @example Update the authenticating user's profile banner
    #   Twitter.update_profile_banner(File.new("me.jpeg"))
    def update_profile_banner(banner, options={})
      post("/1.1/account/update_profile_banner.json", options.merge(:banner => banner))[:body]
    end

    # Removes the authenticating user's profile banner image
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/remove_profile_banner
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [nil]
    # @param options [Hash] A customizable set of options.
    # @example Remove the authenticating user's profile banner image
    #   Twitter.remove_profile_banner
    def remove_profile_banner(options={})
      post("/1.1/account/remove_profile_banner.json", options)[:body]
    end

    # Updates the authenticating user's settings.
    # Or, if no options supplied, returns settings (including current trend, geo and sleep time information) for the authenticating user.
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/account/settings
    # @see https://dev.twitter.com/docs/api/1.1/get/account/settings
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Settings]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :trend_location_woeid The Yahoo! Where On Earth ID to use as the user's default trend location. Global information is available by using 1 as the WOEID. The woeid must be one of the locations returned by {https://dev.twitter.com/docs/api/1.1/get/trends/available GET trends/available}.
    # @option options [Boolean, String, Integer] :sleep_time_enabled When set to true, 't' or 1, will enable sleep time for the user. Sleep time is the time when push or SMS notifications should not be sent to the user.
    # @option options [Integer] :start_sleep_time The hour that sleep time should begin if it is enabled. The value for this parameter should be provided in {http://en.wikipedia.org/wiki/ISO_8601 ISO8601} format (i.e. 00-23). The time is considered to be in the same timezone as the user's time_zone setting.
    # @option options [Integer] :end_sleep_time The hour that sleep time should end if it is enabled. The value for this parameter should be provided in {http://en.wikipedia.org/wiki/ISO_8601 ISO8601} format (i.e. 00-23). The time is considered to be in the same timezone as the user's time_zone setting.
    # @option options [String] :time_zone The timezone dates and times should be displayed in for the user. The timezone must be one of the {http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html Rails TimeZone} names.
    # @option options [String] :lang The language which Twitter should render in for this user. The language must be specified by the appropriate two letter ISO 639-1 representation. Currently supported languages are provided by {https://dev.twitter.com/docs/api/1.1/get/help/languages GET help/languages}.
    # @example Return the settings for the authenticating user.
    #   Twitter.settings
    def settings(options={})
      request_method = options.size.zero? ? :get : :post
      object_from_response(Twitter::Settings, request_method, "/1.1/account/settings.json", options)
    end

    # Returns activity about me
    #
    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array] An array of actions
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @example Return activity about me
    #   Twitter.activity_about_me
    def activity_about_me(options={})
      collection_from_response(Twitter::ActionFactory, :get, "/i/activity/about_me.json", options)
    end

    # Returns activity by friends
    #
    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid./
    # @return [Array] An array of actions
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @example Return activity by friends
    #   Twitter.activity_by_friends
    def activity_by_friends(options={})
      collection_from_response(Twitter::ActionFactory, :get, "/i/activity/by_friends.json", options)
    end

    # Returns the 20 most recent direct messages sent to the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::DirectMessage>] Direct messages sent to the authenticating user.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @example Return the 20 most recent direct messages sent to the authenticating user
    #   Twitter.direct_messages_received
    def direct_messages_received(options={})
      collection_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages.json", options)
    end

    # Returns the 20 most recent direct messages sent by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/sent
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::DirectMessage>] Direct messages sent by the authenticating user.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @example Return the 20 most recent direct messages sent by the authenticating user
    #   Twitter.direct_messages_sent
    def direct_messages_sent(options={})
      collection_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages/sent.json", options)
    end

    # Destroys direct messages
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/direct_messages/destroy
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::DirectMessage>] Deleted direct message.
    # @overload direct_message_destroy(*ids)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Destroys the direct message with the ID 1825785544
    #     Twitter.direct_message_destroy(1825785544)
    # @overload direct_message_destroy(*ids, options)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def direct_message_destroy(*args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::DirectMessage, :post, "/1.1/direct_messages/destroy.json", options.merge(:id => id))
      end
    end

    # Sends a new direct message to the specified user from the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/direct_messages/new
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::DirectMessage] The sent message.
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param text [String] The text of your direct message, up to 140 characters.
    # @param options [Hash] A customizable set of options.
    # @example Send a direct message to @sferik from the authenticating user
    #   Twitter.direct_message_create('sferik', "I'm sending you this message via @gem!")
    #   Twitter.direct_message_create(7505382, "I'm sending you this message via @gem!")  # Same as above
    def direct_message_create(user, text, options={})
      options.merge_user!(user)
      options[:text] = text
      object_from_response(Twitter::DirectMessage, :post, "/1.1/direct_messages/new.json", options)
    end
    alias d direct_message_create
    alias m direct_message_create

    # Returns a direct message
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::DirectMessage] The requested messages.
    # @param id [Integer] A Tweet IDs.
    # @param options [Hash] A customizable set of options.
    # @example Return the direct message with the id 1825786345
    #   Twitter.direct_message(1825786345)
    def direct_message(id, options={})
      options[:id] = id
      object_from_response(Twitter::DirectMessage, :get, "/1.1/direct_messages/show.json", options)
    end

    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::DirectMessage>] The requested messages.
    # @overload direct_messages(options={})
    #   Returns the 20 most recent direct messages sent to the authenticating user
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Integer] :page Specifies the page of results to retrieve.
    #   @example Return the 20 most recent direct messages sent to the authenticating user
    #     Twitter.direct_messages
    # @overload direct_messages(*ids)
    #   Returns direct messages
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Return the direct message with the id 1825786345
    #     Twitter.direct_messages(1825786345)
    # @overload direct_messages(*ids, options)
    #   Returns direct messages
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/direct_messages/show
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def direct_messages(*args)
      options = args.extract_options!
      if args.empty?
        direct_messages_received(options)
      else
        args.flatten.threaded_map do |id|
          direct_message(id, options)
        end
      end
    end

    # @see https://dev.twitter.com/docs/api/1.1/get/followers/ids
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @overload follower_ids(options={})
    #   Returns an array of numeric IDs for every user following the authenticated user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the authenticated user's followers' IDs
    #     Twitter.follower_ids
    # @overload follower_ids(user, options={})
    #   Returns an array of numeric IDs for every user following the specified user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return @sferik's followers' IDs
    #     Twitter.follower_ids('sferik')
    #     Twitter.follower_ids(7505382)  # Same as above
    def follower_ids(*args)
      ids_from_response(:get, "/1.1/followers/ids.json", args)
    end

    # @see https://dev.twitter.com/docs/api/1.1/get/friends/ids
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @overload friend_ids(options={})
    #   Returns an array of numeric IDs for every user the authenticated user is following
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the authenticated user's friends' IDs
    #     Twitter.friend_ids
    # @overload friend_ids(user, options={})
    #   Returns an array of numeric IDs for every user the specified user is following
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return @sferik's friends' IDs
    #     Twitter.friend_ids('sferik')
    #     Twitter.friend_ids(7505382)  # Same as above
    def friend_ids(*args)
      ids_from_response(:get, "/1.1/friends/ids.json", args)
    end

    # Test for the existence of friendship between two users
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/friendships/show
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Boolean] true if user_a follows user_b, otherwise false.
    # @param source [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the source user.
    # @param target [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the target user.
    # @param options [Hash] A customizable set of options.
    # @example Return true if @sferik follows @pengwynn
    #   Twitter.friendship?('sferik', 'pengwynn')
    #   Twitter.friendship?('sferik', 14100886)   # Same as above
    #   Twitter.friendship?(7505382, 14100886)    # Same as above
    def friendship?(source, target, options={})
      friendship(source, target, options).source.following?
    end

    # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/friendships/incoming
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
    #   Twitter.friendships_incoming
    def friendships_incoming(options={})
      merge_default_cursor!(options)
      cursor_from_response(:ids, nil, :get, "/1.1/friendships/incoming.json", options)
    end

    # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/friendships/outgoing
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
    #   Twitter.friendships_outgoing
    def friendships_outgoing(options={})
      merge_default_cursor!(options)
      cursor_from_response(:ids, nil, :get, "/1.1/friendships/outgoing.json", options)
    end

    # Returns detailed information about the relationship between two users
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/friendships/show
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Relationship]
    # @param source [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the source user.
    # @param target [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the target user.
    # @param options [Hash] A customizable set of options.
    # @example Return the relationship between @sferik and @pengwynn
    #   Twitter.friendship('sferik', 'pengwynn')
    #   Twitter.friendship('sferik', 14100886)   # Same as above
    #   Twitter.friendship(7505382, 14100886)    # Same as above
    def friendship(source, target, options={})
      options.merge_user!(source, "source")
      options[:source_id] = options.delete(:source_user_id) unless options[:source_user_id].nil?
      options.merge_user!(target, "target")
      options[:target_id] = options.delete(:target_user_id) unless options[:target_user_id].nil?
      object_from_response(Twitter::Relationship, :get, "/1.1/friendships/show.json", options)
    end
    alias friendship_show friendship
    alias relationship friendship

    # Allows the authenticating user to follow the specified users, unless they are already followed
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/friendships/create
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The followed users.
    # @overload(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Follow @sferik
    #     Twitter.follow('sferik')
    # @overload(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean] :follow (false) Enable notifications for the target user.
    def follow(*args)
      options = args.extract_options!
      # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
      # so only send follow if it's true
      options[:follow] = true if !!options.delete(:follow)
      existing_friends = Thread.new do
        friend_ids.ids
      end
      new_friends = Thread.new do
        users(args).map(&:id)
      end
      follow!(new_friends.value - existing_friends.value, options)
    end
    alias friendship_create follow

    # Allows the authenticating user to follow the specified users
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/friendships/create
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The followed users.
    # @overload follow!(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Follow @sferik
    #     Twitter.follow!('sferik')
    # @overload follow!(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean] :follow (false) Enable notifications for the target user.
    def follow!(*args)
      options = args.extract_options!
      # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
      # so only send follow if it's true
      options[:follow] = true if !!options.delete(:follow)
      args.flatten.threaded_map do |user|
        begin
          options.merge_user!(user)
          object_from_response(Twitter::User, :post, "/1.1/friendships/create.json", options)
        rescue Twitter::Error::Forbidden
          # This error will be raised if the user doesn't have permission to
          # follow list_member, for whatever reason.
        end
      end.compact
    end
    alias friendship_create! follow!

    # Allows the authenticating user to unfollow the specified users
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/friendships/destroy
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The unfollowed users.
    # @overload unfollow(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Unfollow @sferik
    #     Twitter.unfollow('sferik')
    # @overload unfollow(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def unfollow(*args)
      threaded_users_from_response(:post, "/1.1/friendships/destroy.json", args)
    end
    alias friendship_destroy unfollow

    # Returns the relationship of the authenticating user to the comma separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/friendships/lookup
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The requested users.
    # @overload friendships(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Return extended information for @sferik and @pengwynn
    #     Twitter.friendships('sferik', 'pengwynn')
    #     Twitter.friendships('sferik', 14100886)   # Same as above
    #     Twitter.friendships(7505382, 14100886)    # Same as above
    # @overload friendships(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def friendships(*args)
      options = args.extract_options!
      options.merge_users!(Array(args))
      collection_from_response(Twitter::User, :get, "/1.1/friendships/lookup.json", options)
    end

    # Allows one to enable or disable retweets and device notifications from the specified user.
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/friendships/update
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Relationship]
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :device Enable/disable device notifications from the target user.
    # @option options [Boolean] :retweets Enable/disable retweets from the target user.
    # @example Enable rewteets and devise notifications for @sferik
    #   Twitter.friendship_update('sferik', :device => true, :retweets => true)
    def friendship_update(user, options={})
      options.merge_user!(user)
      object_from_response(Twitter::Relationship, :post, "/1.1/friendships/update.json", options)
    end

    # Search for places that can be attached to a {Twitter::API::Statuses#update}
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/geo/search
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @option options [Float] :lat The latitude to search around. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude to search around. The valid range for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :query Free-form text to match against while executing a geo-based query, best suited for finding nearby locations by name.
    # @option options [String] :ip An IP address. Used when attempting to fix geolocation based off of the user's IP address.
    # @option options [String] :granularity ('neighborhood') This is the minimal granularity of place types to return and must be one of: 'poi', 'neighborhood', 'city', 'admin' or 'country'.
    # @option options [String] :accuracy ('0m') A hint on the "region" in which to search. If a number, then this is a radius in meters, but it can also take a string that is suffixed with ft to specify feet. If coming from a device, in practice, this value is whatever accuracy the device has measuring its location (whether it be coming from a GPS, WiFi triangulation, etc.).
    # @option options [Integer] :max_results A hint as to the number of results to return. This does not guarantee that the number of results returned will equal max_results, but instead informs how many "nearby" results to return. Ideally, only pass in the number of places you intend to display to the user here.
    # @option options [String] :contained_within This is the place_id which you would like to restrict the search results to. Setting this value means only places within the given place_id will be found.
    # @option options [String] :"attribute:street_address" This option searches for places which have this given street address. There are other well-known and application-specific attributes available. Custom attributes are also permitted.
    # @return [Array<Twitter::Place>]
    # @example Return an array of places near the IP address 74.125.19.104
    #   Twitter.places_nearby(:ip => "74.125.19.104")
    def places_nearby(options={})
      geo_collection_from_response(:get, "/1.1/geo/search.json", options)
    end
    alias geo_search places_nearby

    # Locates places near the given coordinates which are similar in name
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/geo/similar_places
    # @note Conceptually, you would use this method to get a list of known places to choose from first. Then, if the desired place doesn't exist, make a request to {Twitter::API::Geo#place} to create a new one. The token contained in the response is the token necessary to create a new place.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @option options [Float] :lat The latitude to search around. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude to search around. The valid range for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :name The name a place is known as.
    # @option options [String] :contained_within This is the place_id which you would like to restrict the search results to. Setting this value means only places within the given place_id will be found.
    # @option options [String] :"attribute:street_address" This option searches for places which have this given street address. There are other well-known and application-specific attributes available. Custom attributes are also permitted.
    # @return [Array<Twitter::Place>]
    # @example Return an array of places similar to Twitter HQ
    #   Twitter.places_similar(:lat => "37.7821120598956", :long => "-122.400612831116", :name => "Twitter HQ")
    def places_similar(options={})
      geo_collection_from_response(:get, "/1.1/geo/similar_places.json", options)
    end

    # Searches for up to 20 places that can be used as a place_id
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/geo/reverse_geocode
    # @note This request is an informative call and will deliver generalized results about geography.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @option options [Float] :lat The latitude to search around. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude to search around. The valid range for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :accuracy ('0m') A hint on the "region" in which to search. If a number, then this is a radius in meters, but it can also take a string that is suffixed with ft to specify feet. If coming from a device, in practice, this value is whatever accuracy the device has measuring its location (whether it be coming from a GPS, WiFi triangulation, etc.).
    # @option options [String] :granularity ('neighborhood') This is the minimal granularity of place types to return and must be one of: 'poi', 'neighborhood', 'city', 'admin' or 'country'.
    # @option options [Integer] :max_results A hint as to the number of results to return. This does not guarantee that the number of results returned will equal max_results, but instead informs how many "nearby" results to return. Ideally, only pass in the number of places you intend to display to the user here.
    # @return [Array<Twitter::Place>]
    # @example Return an array of places within the specified region
    #   Twitter.reverse_geocode(:lat => "37.7821120598956", :long => "-122.400612831116")
    def reverse_geocode(options={})
      geo_collection_from_response(:get, "/1.1/geo/reverse_geocode.json", options)
    end

    # Returns all the information about a known place
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/geo/id/:place_id
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param place_id [String] A place in the world. These IDs can be retrieved from {Twitter::API::Geo#reverse_geocode}.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Place] The requested place.
    # @example Return all the information about Twitter HQ
    #   Twitter.place("247f43d441defc03")
    def place(place_id, options={})
      object_from_response(Twitter::Place, :get, "/1.1/geo/id/#{place_id}.json", options)
    end

    # Creates a new place at the given latitude and longitude
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/geo/place
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :name The name a place is known as.
    # @option options [String] :contained_within This is the place_id which you would like to restrict the search results to. Setting this value means only places within the given place_id will be found.
    # @option options [String] :token The token found in the response from {Twitter::API::Geo#places_similar}.
    # @option options [Float] :lat The latitude to search around. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude to search around. The valid range for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :"attribute:street_address" This option searches for places which have this given street address. There are other well-known and application-specific attributes available. Custom attributes are also permitted.
    # @return [Twitter::Place] The created place.
    # @example Create a new place
    #   Twitter.place_create(:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581")
    def place_create(options={})
      object_from_response(Twitter::Place, :post, "/1.1/geo/place.json", options)
    end

    # Returns the current configuration used by Twitter
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/help/configuration
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Configuration] Twitter's configuration.
    # @example Return the current configuration used by Twitter
    #   Twitter.configuration
    def configuration(options={})
      object_from_response(Twitter::Configuration, :get, "/1.1/help/configuration.json", options)
    end

    # Returns the list of languages supported by Twitter
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/help/languages
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Language>]
    # @example Return the list of languages Twitter supports
    #   Twitter.languages
    def languages(options={})
      collection_from_response(Twitter::Language, :get, "/1.1/help/languages.json", options)
    end

    # Returns {https://twitter.com/privacy Twitter's Privacy Policy}
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/help/privacy
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [String]
    # @example Return {https://twitter.com/privacy Twitter's Privacy Policy}
    #   Twitter.privacy
    def privacy(options={})
      get("/1.1/help/privacy.json", options)[:body][:privacy]
    end

    # Returns {https://twitter.com/tos Twitter's Terms of Service}
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/help/tos
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [String]
    # @example Return {https://twitter.com/tos Twitter's Terms of Service}
    #   Twitter.tos
    def tos(options={})
      get("/1.1/help/tos.json", options)[:body][:tos]
    end

    # Show tweet timeline for members of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/statuses
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @overload list_timeline(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count The number of results to retrieve.
    #   @example Show tweet timeline for members of the authenticated user's "presidents" list
    #     Twitter.list_timeline('presidents')
    #     Twitter.list_timeline(8863586)
    # @overload list_timeline(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count The number of results to retrieve.
    #   @example Show tweet timeline for members of @sferik's "presidents" list
    #     Twitter.list_timeline('sferik', 'presidents')
    #     Twitter.list_timeline('sferik', 8863586)
    #     Twitter.list_timeline(7505382, 'presidents')
    #     Twitter.list_timeline(7505382, 8863586)
    def list_timeline(*args)
      options = args.extract_options!
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      collection_from_response(Twitter::Tweet, :get, "/1.1/lists/statuses.json", options)
    end

    # Removes the specified member from the list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The list.
    # @overload list_remove_member(list, user_to_remove, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
    #   @param options [Hash] A customizable set of options.
    #   @example Remove @BarackObama from the authenticated user's "presidents" list
    #     Twitter.list_remove_member('presidents', 813286)
    #     Twitter.list_remove_member('presidents', 'BarackObama')
    #     Twitter.list_remove_member(8863586, 'BarackObama')
    # @overload list_remove_member(user, list, user_to_remove, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
    #   @param options [Hash] A customizable set of options.
    #   @example Remove @BarackObama from @sferik's "presidents" list
    #     Twitter.list_remove_member('sferik', 'presidents', 813286)
    #     Twitter.list_remove_member('sferik', 'presidents', 'BarackObama')
    #     Twitter.list_remove_member('sferik', 8863586, 'BarackObama')
    #     Twitter.list_remove_member(7505382, 'presidents', 813286)
    def list_remove_member(*args)
      list_modify_member(:post, "/1.1/lists/members/destroy.json", args)
    end

    # List the lists the specified user has been added to
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/memberships
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @overload memberships(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @option options [Boolean, String, Integer] :filter_to_owned_lists When set to true, t or 1, will return just lists the authenticating user owns, and the user represented by user_id or screen_name is a member of.
    #   @example List the lists the authenticated user has been added to
    #     Twitter.memberships
    # @overload memberships(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @option options [Boolean, String, Integer] :filter_to_owned_lists When set to true, t or 1, will return just lists the authenticating user owns, and the user represented by user_id or screen_name is a member of.
    #   @example List the lists that @sferik has been added to
    #     Twitter.memberships('sferik')
    #     Twitter.memberships(7505382)
    def memberships(*args)
      lists_from_response(:get, "/1.1/lists/memberships.json", args)
    end

    # Returns the subscribers of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor] The subscribers of the specified list.
    # @overload list_subscribers(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the subscribers of the authenticated user's "presidents" list
    #     Twitter.list_subscribers('presidents')
    #     Twitter.list_subscribers(8863586)
    # @overload list_subscribers(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the subscribers of @sferik's "presidents" list
    #     Twitter.list_subscribers('sferik', 'presidents')
    #     Twitter.list_subscribers('sferik', 8863586)
    #     Twitter.list_subscribers(7505382, 'presidents')
    def list_subscribers(*args)
      list_users(:get, "/1.1/lists/subscribers.json", args)
    end

    # List the lists the specified user follows
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscriptions
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @overload subscriptions(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example List the lists the authenticated user follows
    #     Twitter.subscriptions
    # @overload subscriptions(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example List the lists that @sferik follows
    #     Twitter.subscriptions('sferik')
    #     Twitter.subscriptions(7505382)
    def subscriptions(*args)
      lists_from_response(:get, "/1.1/lists/subscriptions.json", args)
    end

    # Make the authenticated user follow the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/create
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The specified list.
    # @overload list_subscribe(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Subscribe to the authenticated user's "presidents" list
    #     Twitter.list_subscribe('presidents')
    #     Twitter.list_subscribe(8863586)
    # @overload list_subscribe(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Subscribe to @sferik's "presidents" list
    #     Twitter.list_subscribe('sferik', 'presidents')
    #     Twitter.list_subscribe('sferik', 8863586)
    #     Twitter.list_subscribe(7505382, 'presidents')
    def list_subscribe(*args)
      list_from_response(:post, "/1.1/lists/subscribers/create.json", args)
    end

    # Check if a user is a subscriber of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/subscribers/show
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
    # @overload list_subscriber?(list, user_to_check, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
    #     Twitter.list_subscriber?('presidents', 813286)
    #     Twitter.list_subscriber?(8863586, 813286)
    #     Twitter.list_subscriber?('presidents', 'BarackObama')
    # @overload list_subscriber?(user, list, user_to_check, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
    #     Twitter.list_subscriber?('sferik', 'presidents', 813286)
    #     Twitter.list_subscriber?('sferik', 8863586, 813286)
    #     Twitter.list_subscriber?(7505382, 'presidents', 813286)
    #     Twitter.list_subscriber?('sferik', 'presidents', 'BarackObama')
    # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
    def list_subscriber?(*args)
      list_user?(:get, "/1.1/lists/subscribers/show.json", args)
    end

    # Unsubscribes the authenticated user form the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/destroy
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The specified list.
    # @overload list_unsubscribe(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Unsubscribe from the authenticated user's "presidents" list
    #     Twitter.list_unsubscribe('presidents')
    #     Twitter.list_unsubscribe(8863586)
    # @overload list_unsubscribe(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Unsubscribe from @sferik's "presidents" list
    #     Twitter.list_unsubscribe('sferik', 'presidents')
    #     Twitter.list_unsubscribe('sferik', 8863586)
    #     Twitter.list_unsubscribe(7505382, 'presidents')
    def list_unsubscribe(*args)
      list_from_response(:post, "/1.1/lists/subscribers/destroy.json", args)
    end

    # Adds specified members to a list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/create_all
    # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The list.
    # @overload list_add_members(list, users, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @example Add @BarackObama and @pengwynn to the authenticated user's "presidents" list
    #     Twitter.list_add_members('presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members('presidents', [813286, 18755393])
    #     Twitter.list_add_members(8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members(8863586, [813286, 18755393])
    # @overload list_add_members(user, list, users, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @example Add @BarackObama and @pengwynn to @sferik's "presidents" list
    #     Twitter.list_add_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members('sferik', 'presidents', [813286, 18755393])
    #     Twitter.list_add_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members(7505382, 'presidents', [813286, 18755393])
    #     Twitter.list_add_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members(7505382, 8863586, [813286, 18755393])
    def list_add_members(*args)
      list_modify_members(:post, "/1.1/lists/members/create_all.json", args)
    end

    # Removes specified members from the list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy_all
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The list.
    # @overload list_remove_members(list, users, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @example Remove @BarackObama and @pengwynn from the authenticated user's "presidents" list
    #     Twitter.list_remove_members('presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members('presidents', [813286, 18755393])
    #     Twitter.list_remove_members(8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members(8863586, [813286, 18755393])
    # @overload list_remove_members(user, list, users, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @example Remove @BarackObama and @pengwynn from @sferik's "presidents" list
    #     Twitter.list_remove_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members('sferik', 'presidents', [813286, 18755393])
    #     Twitter.list_remove_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members(7505382, 'presidents', [813286, 18755393])
    #     Twitter.list_remove_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members(7505382, 8863586, [813286, 18755393])
    def list_remove_members(*args)
      list_modify_members(:post, "/1.1/lists/members/destroy_all.json", args)
    end

    # Check if a user is a member of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/members/show
    # @authentication_required Requires user context
    # @rate_limited Yes
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Boolean] true if user is a member of the specified list, otherwise false.
    # @overload list_member?(list, user_to_check, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
    #   @param options [Hash] A customizable set of options.
    #   @example Check if @BarackObama is a member of the authenticated user's "presidents" list
    #     Twitter.list_member?('presidents', 813286)
    #     Twitter.list_member?(8863586, 'BarackObama')
    # @overload list_member?(user, list, user_to_check, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
    #   @param options [Hash] A customizable set of options.
    #   @example Check if @BarackObama is a member of @sferik's "presidents" list
    #     Twitter.list_member?('sferik', 'presidents', 813286)
    #     Twitter.list_member?('sferik', 8863586, 'BarackObama')
    #     Twitter.list_member?(7505382, 'presidents', 813286)
    def list_member?(*args)
      list_user?(:get, "/1.1/lists/members/show.json", args)
    end

    # Returns the members of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/members
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Cursor]
    # @overload list_members(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the members of the authenticated user's "presidents" list
    #     Twitter.list_members('presidents')
    #     Twitter.list_members(8863586)
    # @overload list_members(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @example Return the members of @sferik's "presidents" list
    #     Twitter.list_members('sferik', 'presidents')
    #     Twitter.list_members('sferik', 8863586)
    #     Twitter.list_members(7505382, 'presidents')
    #     Twitter.list_members(7505382, 8863586)
    def list_members(*args)
      list_users(:get, "/1.1/lists/members.json", args)
    end

    # Add a member to a list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/members/create
    # @note Lists are limited to having 500 members.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The list.
    # @overload list_add_member(list, user_to_add, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
    #   @param options [Hash] A customizable set of options.
    #   @example Add @BarackObama to the authenticated user's "presidents" list
    #     Twitter.list_add_member('presidents', 813286)
    #     Twitter.list_add_member(8863586, 813286)
    # @overload list_add_member(user, list, user_to_add, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
    #   @param options [Hash] A customizable set of options.
    #   @example Add @BarackObama to @sferik's "presidents" list
    #     Twitter.list_add_member('sferik', 'presidents', 813286)
    #     Twitter.list_add_member('sferik', 8863586, 813286)
    #     Twitter.list_add_member(7505382, 'presidents', 813286)
    #     Twitter.list_add_member(7505382, 8863586, 813286)
    def list_add_member(*args)
      list_modify_member(:post, "/1.1/lists/members/create.json", args)
    end

    # Deletes the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/destroy
    # @note Must be owned by the authenticated user.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The deleted list.
    # @overload list_destroy(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Delete the authenticated user's "presidents" list
    #     Twitter.list_destroy('presidents')
    #     Twitter.list_destroy(8863586)
    # @overload list_destroy(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Delete @sferik's "presidents" list
    #     Twitter.list_destroy('sferik', 'presidents')
    #     Twitter.list_destroy('sferik', 8863586)
    #     Twitter.list_destroy(7505382, 'presidents')
    #     Twitter.list_destroy(7505382, 8863586)
    def list_destroy(*args)
      list_from_response(:post, "/1.1/lists/destroy.json", args)
    end

    # Updates the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/update
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The created list.
    # @overload list_update(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    #   @option options [String] :description The description to give the list.
    #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
    #     Twitter.list_update('presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update(8863586, :description => "Presidents of the United States of America")
    # @overload list_update(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    #   @option options [String] :description The description to give the list.
    #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
    #     Twitter.list_update('sferik', 'presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update(7505382, 'presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update('sferik', 8863586, :description => "Presidents of the United States of America")
    #     Twitter.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
    def list_update(*args)
      list_from_response(:post, "/1.1/lists/update.json", args)
    end

    # Creates a new list for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/lists/create
    # @note Accounts are limited to 20 lists.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The created list.
    # @param name [String] The name for the list.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    # @option options [String] :description The description to give the list.
    # @example Create a list named 'presidents'
    #   Twitter.list_create('presidents')
    def list_create(name, options={})
      object_from_response(Twitter::List, :post, "/1.1/lists/create.json", options.merge(:name => name))
    end

    # Returns all lists the authenticating or specified user subscribes to, including their own
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/list
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::List>]
    # @overload memberships(options={})
    #   @param options [Hash] A customizable set of options.
    #   @example Returns all lists the authenticating user subscribes to
    #     Twitter.lists
    # @overload memberships(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Returns all lists that @sferik subscribes to
    #     Twitter.lists('sferik')
    #     Twitter.lists(7505382)
    def lists(*args)
      objects_from_response(Twitter::List, :get, "/1.1/lists/list.json", args)
    end
    alias lists_subscribed_to lists

    # Show the specified list
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/lists/show
    # @note Private lists will only be shown if the authenticated user owns the specified list.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::List] The specified list.
    # @overload list(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Show the authenticated user's "presidents" list
    #     Twitter.list('presidents')
    #     Twitter.list(8863586)
    # @overload list(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Show @sferik's "presidents" list
    #     Twitter.list('sferik', 'presidents')
    #     Twitter.list('sferik', 8863586)
    #     Twitter.list(7505382, 'presidents')
    #     Twitter.list(7505382, 8863586)
    def list(*args)
      list_from_response(:get, "/1.1/lists/show.json", args)
    end

    # The users specified are blocked by the authenticated user and reported as spammers
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/report_spam
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The reported users.
    # @overload report_spam(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Report @spam for spam
    #     Twitter.report_spam("spam")
    #     Twitter.report_spam(14589771) # Same as above
    # @overload report_spam(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def report_spam(*args)
      threaded_users_from_response(:post, "/1.1/report_spam.json", args)
    end

    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::SavedSearch>] The saved searches.
    # @overload saved_search(options={})
    #   Returns the authenticated user's saved search queries
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/list
    #   @param options [Hash] A customizable set of options.
    #   @example Return the authenticated user's saved search queries
    #     Twitter.saved_searches
    # @overload saved_search(*ids)
    #   Retrieve the data for saved searches owned by the authenticating user
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
    #     Twitter.saved_search(16129012)
    # @overload saved_search(*ids, options)
    #   Retrieve the data for saved searches owned by the authenticating user
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def saved_searches(*args)
      options = args.extract_options!
      if args.empty?
        collection_from_response(Twitter::SavedSearch, :get, "/1.1/saved_searches/list.json", options)
      else
        args.flatten.threaded_map do |id|
          object_from_response(Twitter::SavedSearch, :get, "/1.1/saved_searches/show/#{id}.json", options)
        end
      end
    end

    # Retrieve the data for saved searches owned by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/saved_searches/show/:id
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::SavedSearch] The saved searches.
    # @param id [Integer] A Tweet IDs.
    # @param options [Hash] A customizable set of options.
    # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
    #   Twitter.saved_search(16129012)
    def saved_search(id, options={})
      object_from_response(Twitter::SavedSearch, :get, "/1.1/saved_searches/show/#{id}.json", options)
    end

    # Creates a saved search for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/saved_searches/create
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::SavedSearch] The created saved search.
    # @param query [String] The query of the search the user would like to save.
    # @param options [Hash] A customizable set of options.
    # @example Create a saved search for the authenticated user with the query "twitter"
    #   Twitter.saved_search_create("twitter")
    def saved_search_create(query, options={})
      object_from_response(Twitter::SavedSearch, :post, "/1.1/saved_searches/create.json", options.merge(:query => query))
    end

    # Destroys saved searches for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/saved_searches/destroy/:id
    # @note The search specified by ID must be owned by the authenticating user.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::SavedSearch>] The deleted saved searches.
    # @overload saved_search_destroy(*ids)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Destroys a saved search for the authenticated user with the ID 16129012
    #     Twitter.saved_search_destroy(16129012)
    # @overload saved_search_destroy(*ids, options)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def saved_search_destroy(*args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::SavedSearch, :post, "/1.1/saved_searches/destroy/#{id}.json", options)
      end
    end

    # Returns tweets that match a specified query.
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/search/tweets
    # @see https://dev.twitter.com/docs/using-search
    # @note Please note that Twitter's search service and, by extension, the Search API is not meant to be an exhaustive source of Tweets. Not all Tweets will be indexed or made available via the search interface.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :geocode Returns tweets by users located within a given radius of the given latitude/longitude. The location is preferentially taking from the Geotagging API, but will fall back to their Twitter profile. The parameter value is specified by "latitude,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers). Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly.
    # @option options [String] :lang Restricts tweets to the given language, given by an ISO 639-1 code.
    # @option options [String] :locale Specify the language of the query you are sending (only ja is currently effective). This is intended for language-specific clients and the default should work in the majority of cases.
    # @option options [String] :result_type Specifies what type of search results you would prefer to receive. Options are "mixed", "recent", and "popular". The current default is "mixed."
    # @option options [Integer] :count The number of tweets to return per page, up to a maximum of 100.
    # @option options [String] :until Optional. Returns tweets generated before the given date. Date should be formatted as YYYY-MM-DD.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID. There are limits to the number of Tweets which can be accessed through the API. If the limit of Tweets has occured since the since_id, the since_id will be forced to the oldest ID available.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Boolean, String, Integer] :include_entities Specifies that each tweet should include an 'entities' node including metadata about the tweet such as: user_mentions, urls, and hashtags.
    # @return [Twitter::SearchResults] Return tweets that match a specified query with search metadata
    # @example Returns tweets related to twitter
    #   Twitter.search('twitter')
    def search(q, options={})
      object_from_response(Twitter::SearchResults, :get, "/1.1/search/tweets.json", options.merge(:q => q))
    end

    # Returns recent Tweets related to a query with images and videos embedded
    #
    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required No
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @return [Array<Twitter::Tweet>] An array of Tweets that contain videos
    # @example Return recent Tweets related to twitter with images and videos embedded
    #   Twitter.phoenix_search('twitter')
    def phoenix_search(q, options={})
      search_collection_from_response(:get, "/phoenix_search.phoenix", options.merge(:q => q))
    end

    # @see https://dev.twitter.com/docs/api/1.1/get/favorites/list
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>] favorite Tweets.
    # @overload favorites(options={})
    #   Returns the 20 most recent favorite Tweets for the authenticating user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @example Return the 20 most recent favorite Tweets for the authenticating user
    #     Twitter.favorites
    # @overload favorites(user, options={})
    #   Returns the 20 most recent favorite Tweets for the specified user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @example Return the 20 most recent favorite Tweets for @sferik
    #     Twitter.favorites('sferik')
    def favorites(*args)
      options = args.extract_options!
      if user = args.pop
        options.merge_user!(user)
      end
      collection_from_response(Twitter::Tweet, :get, "/1.1/favorites/list.json", options)
    end

    # Favorites the specified Tweets as the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/favorites/create
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>] The favorited Tweets.
    # @overload favorite(*ids)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Favorite the Tweet with the ID 25938088801
    #     Twitter.favorite(25938088801)
    # @overload favorite(*ids, options)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def favorite(*args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::Tweet, :post, "/1.1/favorites/create.json", options.merge(:id => id))
      end
    end
    alias fav favorite
    alias fave favorite
    alias favorite_create favorite

    # Un-favorites the specified Tweets as the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/favorites/destroy
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>] The un-favorited Tweets.
    # @overload unfavorite(*ids)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Un-favorite the tweet with the ID 25938088801
    #     Twitter.unfavorite(25938088801)
    # @overload unfavorite(*ids, options)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def unfavorite(*args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::Tweet, :post, "/1.1/favorites/destroy.json", options.merge(:id => id))
      end
    end
    alias favorite_destroy unfavorite

    # Returns the 20 most recent Tweets, including retweets if they exist, posted by the authenticating user and the users they follow
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
    # @note This method can only return up to 800 Tweets, including retweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @option options [Boolean, String, Integer] :include_rts Specifies that the timeline should include native retweets in addition to regular tweets. Note: If you're using the trim_user parameter in conjunction with include_rts, the retweets will no longer contain a full user object.
    # @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    # @option options [Boolean, String, Integer] :include_entities Specifies that each tweet should include an 'entities' node including metadata about the tweet such as: user_mentions, urls, and hashtags.
    # @example Return the 20 most recent Tweets, including retweets if they exist, posted by the authenticating user and the users they follow
    #   Twitter.home_timeline
    def home_timeline(options={})
      collection_from_response(Twitter::Tweet, :get, "/1.1/statuses/home_timeline.json", options)
    end

    # Returns the 20 most recent mentions (statuses containing @username) for the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/mentions_timeline
    # @note This method can only return up to 800 Tweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @example Return the 20 most recent mentions (statuses containing @username) for the authenticating user
    #   Twitter.mentions
    def mentions_timeline(options={})
      collection_from_response(Twitter::Tweet, :get, "/1.1/statuses/mentions_timeline.json", options)
    end
    alias mentions mentions_timeline

    # Returns the 20 most recent retweets posted by the specified user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
    # @note This method can only return up to 3,200 Tweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    # @example Return the 20 most recent retweets posted by @sferik
    #   Twitter.retweeted_by_user('sferik')
    def retweeted_by_user(user, options={})
      options[:include_rts] = true
      count = options[:count] || DEFAULT_TWEETS_PER_REQUEST
      collect_with_count(count) do |count_options|
        select_retweets(user_timeline(user, options.merge(count_options)))
      end
    end
    alias retweeted_by retweeted_by_user

    # Returns the 20 most recent retweets posted by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
    # @note This method can only return up to 3,200 Tweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    # @example Return the 20 most recent retweets posted by the authenticating user
    #   Twitter.retweeted_by_me
    def retweeted_by_me(options={})
      options[:include_rts] = true
      count = options[:count] || DEFAULT_TWEETS_PER_REQUEST
      collect_with_count(count) do |count_options|
        select_retweets(user_timeline(options.merge(count_options)))
      end
    end

    # Returns the 20 most recent retweets posted by users the authenticating user follow.
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
    # @note This method can only return up to 800 Tweets, including retweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    # @option options [Boolean, String, Integer] :include_entities Specifies that each tweet should include an 'entities' node including metadata about the tweet such as: user_mentions, urls, and hashtags.
    # @example Return the 20 most recent retweets posted by users followed by the authenticating user
    #   Twitter.retweeted_to_me
    def retweeted_to_me(options={})
      options[:include_rts] = true
      count = options[:count] || DEFAULT_TWEETS_PER_REQUEST
      collect_with_count(count) do |count_options|
        select_retweets(home_timeline(options.merge(count_options)))
      end
    end

    # Returns the 20 most recent tweets of the authenticated user that have been retweeted by others
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
    # @note This method can only return up to 3,200 Tweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    # @example Return the 20 most recent tweets of the authenticated user that have been retweeted by others
    #   Twitter.retweets_of_me
    def retweets_of_me(options={})
      options[:include_rts] = false
      count = options[:count] || DEFAULT_TWEETS_PER_REQUEST
      collect_with_count(count) do |count_options|
        user_timeline(options.merge(count_options)).select{|tweet| tweet.retweet_count.to_i > 0}
      end
    end

    # Returns the 20 most recent Tweets posted by the specified user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
    # @note This method can only return up to 3,200 Tweets.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @overload user_timeline(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    #   @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    #   @option options [Boolean, String, Integer] :contributor_details Specifies that the contributors element should be enhanced to include the screen_name of the contributor.
    #   @option options [Boolean, String, Integer] :include_rts Specifies that the timeline should include native retweets in addition to regular tweets. Note: If you're using the trim_user parameter in conjunction with include_rts, the retweets will no longer contain a full user object.
    #   @example Return the 20 most recent Tweets posted by @sferik
    #     Twitter.user_timeline('sferik')
    def user_timeline(*args)
      objects_from_response(Twitter::Tweet, :get, "/1.1/statuses/user_timeline.json", args)
    end

    # Returns the 20 most recent images posted by the specified user
    #
    # @see https://support.twitter.com/articles/20169409
    # @note This method can only return up to the 100 most recent images.
    # @note Images will not be returned from tweets posted before January 1, 2010.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @overload media_timeline(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean] :filter Include possibly sensitive media when set to false, 'f' or 0.
    #   @example Return the 20 most recent Tweets posted by @sferik
    #     Twitter.media_timeline('sferik')
    def media_timeline(*args)
      objects_from_response(Twitter::Tweet, :get, "/1.1/statuses/media_timeline.json", args)
    end

    # Show up to 100 users who retweeted the Tweet
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
    # @rate_limited Yes
    # @authentication_required Requires user context
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
      if ids_only = !!options.delete(:ids_only)
        retweets(id, options).map(&:user).map(&:id)
      else
        retweets(id, options).map(&:user)
      end
    end

    # Returns up to 100 of the first retweets of a given tweet
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/:id
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>]
    # @param id [Integer] The numerical ID of the desired Tweet.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @example Return up to 100 of the first retweets of the Tweet with the ID 28561922516
    #   Twitter.retweets(28561922516)
    def retweets(id, options={})
      collection_from_response(Twitter::Tweet, :get, "/1.1/statuses/retweets/#{id}.json", options)
    end

    # Returns a Tweet
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/show/:id
    # @rate_limited Yes
    # @authentication_required Requires user context
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
    # @authentication_required Requires user context
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

    # Returns activity summary for a Tweet
    #
    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Tweet] The requested Tweet.
    # @param id [Integer] A Tweet ID.
    # @param options [Hash] A customizable set of options.
    # @example Return activity summary for the Tweet with the ID 25938088801
    #   Twitter.status_activity(25938088801)
    def status_activity(id, options={})
      response = get("/i/statuses/#{id}/activity/summary.json", options)
      response[:body].merge!(:id => id) if response[:body]
      Twitter::Tweet.from_response(response)
    end
    alias tweet_activity status_activity

    # Returns activity summary for Tweets
    #
    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::Tweet>] The requested Tweets.
    # @overload statuses_activity(*ids)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @example Return activity summary for the Tweet with the ID 25938088801
    #     Twitter.statuses_activity(25938088801)
    # @overload statuses_activity(*ids, options)
    #   @param ids [Array<Integer>, Set<Integer>] An array of Tweet IDs.
    #   @param options [Hash] A customizable set of options.
    def statuses_activity(*args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        status_activity(id, options)
      end
    end

    # Returns oEmbed for a Tweet
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::OEmbed] OEmbed for the requested Tweet.
    # @param id [Integer, String] A Tweet ID.
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
    def oembed(id, options={})
      object_from_response(Twitter::OEmbed, :get, "/1.1/statuses/oembed.json?id=#{id}", options)
    end

    # Returns oEmbeds for Tweets
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/statuses/oembed
    # @rate_limited Yes
    # @authentication_required Requires user context
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
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::OEmbed, :get, "/1.1/statuses/oembed.json?id=#{id}", options)
      end
    end

    # Destroys the specified Tweets
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/:id
    # @note The authenticating user must be the author of the specified Tweets.
    # @rate_limited No
    # @authentication_required Requires user context
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

    # Retweets tweets
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/:id
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Forbidden] Error raised when tweet has already been retweeted.
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
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        response = post("/1.1/statuses/retweet/#{id}.json", options)
        retweeted_status = response.dup
        retweeted_status[:body] = response[:body].delete(:retweeted_status)
        retweeted_status[:body][:retweeted_status] = response[:body]
        Twitter::Tweet.from_response(retweeted_status)
      end
    end

    # Updates the authenticating user's status
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/statuses/update
    # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Tweet] The created Tweet.
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
      object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update.json", options.merge(:status => status))
    end

    # Updates the authenticating user's status with media
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media
    # @note A status update with text/media identical to the authenticating user's current status will NOT be ignored
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::Tweet] The created Tweet.
    # @param status [String] The text of your status update, up to 140 characters.
    # @param media [File, Hash] A File object with your picture (PNG, JPEG or GIF)
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :in_reply_to_status_id The ID of an existing Tweet that the update is in reply to.
    # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::API::Geo#reverse_geocode}.
    # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @example Update the authenticating user's status
    #   Twitter.update_with_media("I'm tweeting with @gem!", File.new('my_awesome_pic.jpeg'))
    def update_with_media(status, media, options={})
      object_from_response(Twitter::Tweet, :post, "/1.1/statuses/update_with_media.json", options.merge('media[]' => media, 'status' => status))
    end

    # Returns the top 10 trending topics for a specific WOEID
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/trends/place
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param id [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::API::Trends#trend_locations}. Global information is available by using 1 as the WOEID.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
    # @return [Array<Twitter::Trend>]
    # @example Return the top 10 trending topics for San Francisco
    #   Twitter.trends(2487956)
    def trends(id=1, options={})
      options[:id] = id
      response = get("/1.1/trends/place.json", options)
      collection_from_array(Twitter::Trend, response[:body].first[:trends])
    end
    alias local_trends trends
    alias trends_place trends

    # Returns the locations that Twitter has trending topic information for
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/trends/available
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @return [Array<Twitter::Place>]
    # @example Return the locations that Twitter has trending topic information for
    #   Twitter.trends_available
    def trends_available(options={})
      collection_from_response(Twitter::Place, :get, "/1.1/trends/available.json", options)
    end
    alias trend_locations trends_available

    # Returns the locations that Twitter has trending topic information for, closest to a specified location.
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/trends/closest
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @param options [Hash] A customizable set of options.
    # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
    # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
    # @return [Array<Twitter::Place>]
    # @example Return the locations that Twitter has trending topic information for
    #   Twitter.trends_closest
    def trends_closest(options={})
      collection_from_response(Twitter::Place, :get, "/1.1/trends/closest.json", options)
    end

    # Returns an array of user objects that the authenticating user is blocking
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/blocks/list
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] User objects that the authenticating user is blocking.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @example Return an array of user objects that the authenticating user is blocking
    #   Twitter.blocking
    def blocking(options={})
      merge_default_cursor!(options)
      cursor_from_response(:users, Twitter::User, :get, "/1.1/blocks/list.json", options)
    end

    # Returns an array of numeric user ids the authenticating user is blocking
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/blocks/ids
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array] Numeric user ids the authenticating user is blocking.
    # @param options [Hash] A customizable set of options.
    # @example Return an array of numeric user ids the authenticating user is blocking
    #   Twitter.blocking_ids
    def blocked_ids(*args)
      ids_from_response(:get, "/1.1/blocks/ids.json", args)
    end

    # Returns true if the authenticating user is blocking a target user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/blocks/ids
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @example Check whether the authenticating user is blocking @sferik
    #   Twitter.block?('sferik')
    #   Twitter.block?(7505382)  # Same as above
    def block?(user, options={})
      merge_default_cursor!(options)
      user_id = case user
      when Integer
        user
      when String
        user(user).id
      when Twitter::User
        user.id
      end
      blocked_ids(options).all.map(&:to_i).include?(user_id)
    end

    # Blocks the users specified by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/blocks/create
    # @note Destroys a friendship to the blocked user if it exists.
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The blocked users.
    # @overload block(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Block and unfriend @sferik as the authenticating user
    #     Twitter.block('sferik')
    #     Twitter.block(7505382)  # Same as above
    # @overload block(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def block(*args)
      threaded_users_from_response(:post, "/1.1/blocks/create.json", args)
    end

    # Un-blocks the users specified by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1.1/post/blocks/destroy
    # @rate_limited No
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The un-blocked users.
    # @overload unblock(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Un-block @sferik as the authenticating user
    #     Twitter.unblock('sferik')
    #     Twitter.unblock(7505382)  # Same as above
    # @overload unblock(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def unblock(*args)
      threaded_users_from_response(:post, "/1.1/blocks/destroy.json", args)
    end

    # @return [Array<Twitter::Suggestion>]
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @overload suggestions(options={})
    #   Returns the list of suggested user categories
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions
    #   @param options [Hash] A customizable set of options.
    #   @example Return the list of suggested user categories
    #     Twitter.suggestions
    # @overload suggestions(slug, options={})
    #   Returns the users in a given category
    #
    #   @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions/:slug
    #   @param slug [String] The short name of list or a category.
    #   @param options [Hash] A customizable set of options.
    #   @example Return the users in the Art & Design category
    #     Twitter.suggestions("art-design")
    def suggestions(*args)
      options = args.extract_options!
      if slug = args.pop
        object_from_response(Twitter::Suggestion, :get, "/1.1/users/suggestions/#{slug}.json", options)
      else
        collection_from_response(Twitter::Suggestion, :get, "/1.1/users/suggestions.json", options)
      end
    end

    # Access the users in a given category of the Twitter suggested user list and return their most recent Tweet if they are not a protected user
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/users/suggestions/:slug/members
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @param slug [String] The short name of list or a category.
    # @param options [Hash] A customizable set of options.
    # @return [Array<Twitter::User>]
    # @example Return the users in the Art & Design category and their most recent Tweet if they are not a protected user
    #   Twitter.suggest_users("art-design")
    def suggest_users(slug, options={})
      collection_from_response(Twitter::User, :get, "/1.1/users/suggestions/#{slug}/members.json", options)
    end

    # Returns extended information for up to 100 users
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/users/lookup
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>] The requested users.
    # @overload users(*users)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @example Return extended information for @sferik and @pengwynn
    #     Twitter.users('sferik', 'pengwynn')
    #     Twitter.users(7505382, 14100886)    # Same as above
    # @overload users(*users, options)
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    def users(*args)
      options = args.extract_options!
      args.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
        collection_from_response(Twitter::User, :post, "/1.1/users/lookup.json", options.merge_users(users))
      end.flatten
    end

    # Returns users that match the given query
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/users/search
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>]
    # @param query [String] The search query to run against people search.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count The number of people to retrieve. Maxiumum of 20 allowed per page.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @example Return users that match "Erik Michaels-Ober"
    #   Twitter.user_search("Erik Michaels-Ober")
    def user_search(query, options={})
      collection_from_response(Twitter::User, :get, "/1.1/users/search.json", options.merge(:q => query))
    end

    # @see https://dev.twitter.com/docs/api/1.1/get/users/show
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Twitter::User] The requested user.
    # @overload user(options={})
    #   Returns extended information for the authenticated user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets when set to true, 't' or 1.
    #   @example Return extended information for the authenticated user
    #     Twitter.user
    # @overload user(user, options={})
    #   Returns extended information for a given user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @example Return extended information for @sferik
    #     Twitter.user('sferik')
    #     Twitter.user(7505382)  # Same as above
    def user(*args)
      options = args.extract_options!
      if user = args.pop
        options.merge_user!(user)
        object_from_response(Twitter::User, :get, "/1.1/users/show.json", options)
      else
        verify_credentials(options)
      end
    end

    # Returns true if the specified user exists
    #
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Boolean] true if the user exists, otherwise false.
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @example Return true if @sferik exists
    #   Twitter.user?('sferik')
    #   Twitter.user?(7505382)  # Same as above
    def user?(user, options={})
      options.merge_user!(user)
      get("/1.1/users/show.json", options)
      true
    rescue Twitter::Error::NotFound
      false
    end

    # Returns an array of users that the specified user can contribute to
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/users/contributees
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>]
    # @overload contributees(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
    #   @example Return the authenticated user's contributees
    #     Twitter.contributees
    # @overload contributees(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
    #   @example Return users @sferik can contribute to
    #     Twitter.contributees('sferik')
    #     Twitter.contributees(7505382)  # Same as above
    def contributees(*args)
      users_from_response(:get, "/1.1/users/contributees.json", args)
    end

    # Returns an array of users who can contribute to the specified account
    #
    # @see https://dev.twitter.com/docs/api/1.1/get/users/contributors
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @return [Array<Twitter::User>]
    # @overload contributors(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
    #   @example Return the authenticated user's contributors
    #     Twitter.contributors
    # @overload contributors(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
    #   @example Return users who can contribute to @sferik's account
    #     Twitter.contributors('sferik')
    #     Twitter.contributors(7505382)  # Same as above
    def contributors(*args)
      users_from_response(:get, "/1.1/users/contributors.json", args)
    end

    # @note Undocumented
    # @rate_limited Yes
    # @authentication_required Requires user context
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #
    # @overload following_followers_of(options={})
    #   Returns users following followers of the specified user
    #
    #   @param options [Hash] A customizable set of options.
    #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #     @return [Twitter::Cursor]
    #   @example Return users follow followers of @sferik
    #     Twitter.following_followers_of
    #
    # @overload following_followers_of(user, options={})
    #   Returns users following followers of the authenticated user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #     @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #     @return [Twitter::Cursor]
    #   @example Return users follow followers of @sferik
    #     Twitter.following_followers_of('sferik')
    #     Twitter.following_followers_of(7505382)  # Same as above
    def following_followers_of(*args)
      options = args.extract_options!
      merge_default_cursor!(options)
      options.merge_user!(args.pop || screen_name)
      cursor_from_response(:users, Twitter::User, :get, "/users/following_followers_of.json", options)
    end

  private

    # @param tweets [Array]
    # @return [Array]
    def select_retweets(tweets)
      tweets.select(&:retweet?)
    end

    # @param collection [Array]
    # @param max_id [Integer, NilClass]
    # @return [Array]
    def collect_with_max_id(collection=[], max_id=nil, &block)
      tweets = yield(max_id)
      return collection if tweets.nil?
      collection += tweets
      tweets.empty? ? collection.flatten : collect_with_max_id(collection, tweets.last.id - 1, &block)
    end

    # @param count [Integer]
    # @return [Array]
    def collect_with_count(count, &block)
      options = {}
      options[:count] = MAX_TWEETS_PER_REQUEST
      collect_with_max_id do |max_id|
        options[:max_id] = max_id unless max_id.nil?
        if count > 0
          tweets = yield(options)
          count -= tweets.length
          tweets
        end
      end.flatten.compact[0...count]
    end

    # @param klass [Class]
    # @param array [Array]
    # @return [Array]
    def collection_from_array(klass, array)
      array.map do |element|
        klass.fetch_or_new(element)
      end
    end

    # @param klass [Class]
    # @param request_method [Symbol]
    # @param url [String]
    # @param params [Hash]
    # @param options [Hash]
    # @return [Array]
    def collection_from_response(klass, request_method, url, params={}, options={})
      collection_from_array(klass, send(request_method.to_sym, url, params, options)[:body])
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param options [Hash]
    # @return [Array]
    def geo_collection_from_response(request_method, url, options)
      collection_from_array(Twitter::Place, send(request_method.to_sym, url, options)[:body][:result][:places])
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param options [Hash]
    # @return [Array]
    def search_collection_from_response(request_method, url, options)
      collection_from_array(Twitter::Tweet, send(request_method.to_sym, url, options)[:body][:statuses])
    end

    # @param klass [Class]
    # @param request_method [Symbol]
    # @param url [String]
    # @param params [Hash]
    # @param options [Hash]
    # @return [Object]
    def object_from_response(klass, request_method, url, params={}, options={})
      response = send(request_method.to_sym, url, params, options)
      klass.from_response(response)
    end

    # @param klass [Class]
    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array]
    def objects_from_response(klass, request_method, url, args)
      options = args.extract_options!
      options.merge_user!(args.pop)
      collection_from_response(klass, request_method, url, options)
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Integer>]
    def ids_from_response(request_method, url, args)
      options = args.extract_options!
      merge_default_cursor!(options)
      options.merge_user!(args.pop)
      cursor_from_response(:ids, nil, request_method, url, options, {}, calling_method)
    end

    # @param collection_name [Symbol]
    # @param klass [Class]
    # @param request_method [Symbol]
    # @param url [String]
    # @param params [Hash]
    # @param options [Hash]
    # @return [Twitter::Cursor]
    def cursor_from_response(collection_name, klass, request_method, url, params={}, options={}, method_name=calling_method)
      response = send(request_method.to_sym, url, params, options)
      Twitter::Cursor.from_response(response, collection_name.to_sym, klass, self, method_name, params)
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Twitter::User>]
    def list_from_response(request_method, url, args)
      options = args.extract_options!
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      object_from_response(Twitter::List, request_method, url, options)
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Twitter::List>]
    def lists_from_response(request_method, url, args)
      options = args.extract_options!
      merge_default_cursor!(options)
      options.merge_user!(args.pop)
      cursor_from_response(:lists, Twitter::List, request_method, url, options, {}, calling_method)
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Twitter::User>]
    def users_from_response(request_method, url, args)
      options = args.extract_options!
      options.merge_user!(args.pop || screen_name)
      collection_from_response(Twitter::User, request_method, url, options)
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Twitter::Tweet>]
    def threaded_tweets_from_response(request_method, url, args)
      options = args.extract_options!
      args.flatten.threaded_map do |id|
        object_from_response(Twitter::Tweet, request_method, url + "/#{id}.json", options)
      end
    end

    # @param request_method [Symbol]
    # @param url [String]
    # @param args [Array]
    # @return [Array<Twitter::User>]
    def threaded_users_from_response(request_method, url, args)
      options = args.extract_options!
      args.flatten.threaded_map do |user|
        object_from_response(Twitter::User, request_method, url, options.merge_user(user))
      end
    end

    def list_users(request_method, url, args)
      options = args.extract_options!
      merge_default_cursor!(options)
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      cursor_from_response(:users, Twitter::User, request_method, url, options, {}, calling_method)
    end

    def list_user?(request_method, url, args)
      options = args.extract_options!
      options.merge_user!(args.pop)
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      send(request_method.to_sym, url, options)
      true
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      false
    end

    def list_modify_member(request_method, url, args)
      options = args.extract_options!
      options.merge_user!(args.pop)
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      object_from_response(Twitter::List, request_method, url, options)
    end

    def list_modify_members(request_method, url, args)
      options = args.extract_options!
      members = args.pop
      options.merge_list!(args.pop)
      options.merge_owner!(args.pop || screen_name) unless options[:owner_id] || options[:owner_screen_name]
      members.flatten.each_slice(MAX_USERS_PER_REQUEST).threaded_map do |users|
        object_from_response(Twitter::List, request_method, url, options.merge_users(users))
      end.last
    end

    def merge_default_cursor!(options)
      options[:cursor] = DEFAULT_CURSOR unless options[:cursor]
    end

    def screen_name
      @screen_name ||= verify_credentials.screen_name
    end

  end
end
