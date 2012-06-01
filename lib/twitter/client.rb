require 'twitter/action_factory'
require 'twitter/authenticatable'
require 'twitter/config'
require 'twitter/configuration'
require 'twitter/connection'
require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/direct_message'
require 'twitter/error/forbidden'
require 'twitter/error/not_found'
require 'twitter/favorite'
require 'twitter/follow'
require 'twitter/language'
require 'twitter/list'
require 'twitter/mention'
require 'twitter/metadata'
require 'twitter/oembed'
require 'twitter/photo'
require 'twitter/place'
require 'twitter/point'
require 'twitter/polygon'
require 'twitter/rate_limit_status'
require 'twitter/relationship'
require 'twitter/reply'
require 'twitter/request'
require 'twitter/retweet'
require 'twitter/saved_search'
require 'twitter/search_results'
require 'twitter/settings'
require 'twitter/size'
require 'twitter/status'
require 'twitter/suggestion'
require 'twitter/trend'
require 'twitter/user'

module Twitter
  # Wrapper for the Twitter REST API
  #
  # @note All methods have been separated into modules and follow the same grouping used in {http://dev.twitter.com/doc the Twitter API Documentation}.
  # @see http://dev.twitter.com/pages/every_developer
  class Client

    include Twitter::Authenticatable
    include Twitter::Connection
    include Twitter::Request

    attr_accessor *Config::VALID_OPTIONS_KEYS

    # Initializes a new API object
    #
    # @param attrs [Hash]
    # @return [Twitter::Client]
    def initialize(attrs={})
      attrs = Twitter.options.merge(attrs)
      Config::VALID_OPTIONS_KEYS.each do |key|
        instance_variable_set("@#{key}".to_sym, attrs[key])
      end
    end

    # Returns the configured screen name or the screen name of the authenticated user
    #
    # @return [Twitter::User]
    def current_user
      @current_user ||= Twitter::User.new(self.verify_credentials)
    end

    # Returns the remaining number of API requests available to the requesting user
    #
    # @see https://dev.twitter.com/docs/api/1/get/account/rate_limit_status
    # @rate_limited No
    # @requires_authentication No
    #
    #   This will return the requesting IP's rate limit status. If you want the authenticating user's rate limit status you must authenticate.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::RateLimitStatus]
    # @example Return the remaining number of API requests available to the requesting user
    #   Twitter.rate_limit_status
    def rate_limit_status(options={})
      rate_limit_status = get("/1/account/rate_limit_status.json", options)
      Twitter::RateLimitStatus.new(rate_limit_status)
    end

    # Returns the requesting user if authentication was successful, otherwise raises {Twitter::Error::Unauthorized}
    #
    # @see https://dev.twitter.com/docs/api/1/get/account/verify_credentials
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the requesting user if authentication was successful
    #   Twitter.verify_credentials
    def verify_credentials(options={})
      user = get("/1/account/verify_credentials.json", options)
      Twitter::User.new(user)
    end

    # Ends the session of the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/end_session
    # @rate_limited No
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @return [Hash]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example End the session of the authenticating user
    #   Twitter.end_session
    def end_session(options={})
      post("/1/account/end_session.json", options)
    end

    # Sets which device Twitter delivers updates to for the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/update_delivery_device
    # @rate_limited No
    # @requires_authentication Yes
    # @param device [String] Must be one of: 'sms', 'none'.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Turn SMS updates on for the authenticating user
    #   Twitter.update_delivery_device('sms')
    def update_delivery_device(device, options={})
      user = post("/1/account/update_delivery_device.json", options.merge(:device => device))
      Twitter::User.new(user)
    end

    # Sets values that users are able to set under the "Account" tab of their settings page
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/update_profile
    # @note Only the options specified will be updated.
    # @rate_limited No
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [String] :name Full name associated with the profile. Maximum of 20 characters.
    # @option options [String] :url URL associated with the profile. Will be prepended with "http://" if not present. Maximum of 100 characters.
    # @option options [String] :location The city or country describing where the user of the account is located. The contents are not normalized or geocoded in any way. Maximum of 30 characters.
    # @option options [String] :description A description of the user owning the account. Maximum of 160 characters.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Set authenticating user's name to Erik Michaels-Ober
    #   Twitter.update_profile(:name => "Erik Michaels-Ober")
    def update_profile(options={})
      user = post("/1/account/update_profile.json", options)
      Twitter::User.new(user)
    end

    # Updates the authenticating user's profile background image
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_background_image
    # @rate_limited No
    # @requires_authentication Yes
    # @param image [String] The background image for the profile. Must be a valid GIF, JPG, or PNG image of less than 800 kilobytes in size. Images with width larger than 2048 pixels will be scaled down.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :tile Whether or not to tile the background image. If set to true the background image will be displayed tiled. The image will not be tiled otherwise.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Update the authenticating user's profile background image
    #   Twitter.update_profile_background_image(File.new("we_concept_bg2.png"))
    def update_profile_background_image(image, options={})
      user = post("/1/account/update_profile_background_image.json", options.merge(:image => image))
      Twitter::User.new(user)
    end

    # Sets one or more hex values that control the color scheme of the authenticating user's profile
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_colors
    # @rate_limited No
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [String] :profile_background_color Profile background color.
    # @option options [String] :profile_text_color Profile text color.
    # @option options [String] :profile_link_color Profile link color.
    # @option options [String] :profile_sidebar_fill_color Profile sidebar's background color.
    # @option options [String] :profile_sidebar_border_color Profile sidebar's border color.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Set authenticating user's profile background to black
    #   Twitter.update_profile_colors(:profile_background_color => '000000')
    def update_profile_colors(options={})
      user = post("/1/account/update_profile_colors.json", options)
      Twitter::User.new(user)
    end

    # Updates the authenticating user's profile image
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_image
    # @note This method asynchronously processes the uploaded file before updating the user's profile image URL. You can either update your local cache the next time you request the user's information, or, at least 5 seconds after uploading the image, ask for the updated URL using {Twitter::Client::User#profile_image}.
    # @rate_limited No
    # @requires_authentication Yes
    # @param image [String] The avatar image for the profile. Must be a valid GIF, JPG, or PNG image of less than 700 kilobytes in size. Images with width larger than 500 pixels will be scaled down. Animated GIFs will be converted to a static GIF of the first frame, removing the animation.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The authenticated user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Update the authenticating user's profile image
    #   Twitter.update_profile_image(File.new("me.jpeg"))
    def update_profile_image(image, options={})
      user = post("/1/account/update_profile_image.json", options.merge(:image => image))
      Twitter::User.new(user)
    end

    # Updates the authenticating user's settings.
    # Or, if no options supplied, returns settings (including current trend, geo and sleep time information) for the authenticating user.
    #
    # @see https://dev.twitter.com/docs/api/1/post/account/settings
    # @see https://dev.twitter.com/docs/api/1/get/account/settings
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :trend_location_woeid The Yahoo! Where On Earth ID to use as the user's default trend location. Global information is available by using 1 as the WOEID. The woeid must be one of the locations returned by {https://dev.twitter.com/docs/api/1/get/trends/available GET trends/available}.
    # @option options [Boolean, String, Integer] :sleep_time_enabled When set to true, 't' or 1, will enable sleep time for the user. Sleep time is the time when push or SMS notifications should not be sent to the user.
    # @option options [Integer] :start_sleep_time The hour that sleep time should begin if it is enabled. The value for this parameter should be provided in {http://en.wikipedia.org/wiki/ISO_8601 ISO8601} format (i.e. 00-23). The time is considered to be in the same timezone as the user's time_zone setting.
    # @option options [Integer] :end_sleep_time The hour that sleep time should end if it is enabled. The value for this parameter should be provided in {http://en.wikipedia.org/wiki/ISO_8601 ISO8601} format (i.e. 00-23). The time is considered to be in the same timezone as the user's time_zone setting.
    # @option options [String] :time_zone The timezone dates and times should be displayed in for the user. The timezone must be one of the {http://api.rubyonrails.org/classes/ActiveSupport/TimeZone.html Rails TimeZone} names.
    # @option options [String] :lang The language which Twitter should render in for this user. The language must be specified by the appropriate two letter ISO 639-1 representation. Currently supported languages are provided by {https://dev.twitter.com/docs/api/1/get/help/languages GET help/languages}.
    # @return [Twitter::Settings]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the settings for the authenticating user.
    #   Twitter.settings
    def settings(options={})
      settings = if options.size.zero?
        get("/1/account/settings.json", options)
      else
        post("/1/account/settings.json", options)
      end
      Twitter::Settings.new(settings)
    end

    # Returns activity about me
    #
    # @note Undocumented
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @return [Array] An array of actions
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return activity about me
    #   Twitter.activity_about_me
    def activity_about_me(options={})
      get("/i/activity/about_me.json", options).map do |action|
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
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @return [Array] An array of actions
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid./
    # @example Return activity by friends
    #   Twitter.activity_by_friends
    def activity_by_friends(options={})
      get("/i/activity/by_friends.json", options).map do |action|
        Twitter::ActionFactory.new(action)
      end
    end

    # Returns an array of user objects that the authenticating user is blocking
    #
    # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @return [Array<Twitter::User>] User objects that the authenticating user is blocking.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return an array of user objects that the authenticating user is blocking
    #   Twitter.blocking
    def blocking(options={})
      get("/1/blocks/blocking.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

    # Returns an array of numeric user ids the authenticating user is blocking
    #
    # @see https://dev.twitter.com/docs/api/1/get/blocks/blocking/ids
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @return [Array] Numeric user ids the authenticating user is blocking.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return an array of numeric user ids the authenticating user is blocking
    #   Twitter.blocking_ids
    def blocked_ids(options={})
      get("/1/blocks/blocking/ids.json", options)
    end

    # Returns true if the authenticating user is blocking a target user
    #
    # @see https://dev.twitter.com/docs/api/1/get/blocks/exists
    # @requires_authentication Yes
    # @rate_limited Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Boolean] true if the authenticating user is blocking the target user, otherwise false.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Check whether the authenticating user is blocking @sferik
    #   Twitter.block?('sferik')
    #   Twitter.block?(7505382)  # Same as above
    def block?(user, options={})
      options.merge_user!(user)
      get("/1/blocks/exists.json", options, :raw => true)
      true
    rescue Twitter::Error::NotFound
      false
    end

    # Blocks the user specified by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/blocks/create
    # @note Destroys a friendship to the blocked user if it exists.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The blocked user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Block and unfriend @sferik as the authenticating user
    #   Twitter.block('sferik')
    #   Twitter.block(7505382)  # Same as above
    def block(user, options={})
      options.merge_user!(user)
      user = post("/1/blocks/create.json", options)
      Twitter::User.new(user)
    end

    # Un-blocks the user specified by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/blocks/destroy
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The un-blocked user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Un-block @sferik as the authenticating user
    #   Twitter.unblock('sferik')
    #   Twitter.unblock(7505382)  # Same as above
    def unblock(user, options={})
      options.merge_user!(user)
      user = delete("/1/blocks/destroy.json", options)
      Twitter::User.new(user)
    end

    # Returns the 20 most recent direct messages sent to the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/get/direct_messages
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @return [Array<Twitter::DirectMessage>] Direct messages sent to the authenticating user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the 20 most recent direct messages sent to the authenticating user
    #   Twitter.direct_messages
    def direct_messages(options={})
      get("/1/direct_messages.json", options).map do |direct_message|
        Twitter::DirectMessage.new(direct_message)
      end
    end

    # Returns the 20 most recent direct messages sent by the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/get/direct_messages/sent
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @return [Array<Twitter::DirectMessage>] Direct messages sent by the authenticating user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the 20 most recent direct messages sent by the authenticating user
    #   Twitter.direct_messages_sent
    def direct_messages_sent(options={})
      get("/1/direct_messages/sent.json", options).map do |direct_message|
        Twitter::DirectMessage.new(direct_message)
      end
    end

    # Destroys a direct message
    #
    # @see https://dev.twitter.com/docs/api/1/post/direct_messages/destroy/:id
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited No
    # @requires_authentication Yes
    # @param id [Integer] The ID of the direct message to delete.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::DirectMessage] The deleted message.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Destroys the direct message with the ID 1825785544
    #   Twitter.direct_message_destroy(1825785544)
    def direct_message_destroy(id, options={})
      direct_message = delete("/1/direct_messages/destroy/#{id}.json", options)
      Twitter::DirectMessage.new(direct_message)
    end

    # Sends a new direct message to the specified user from the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/direct_messages/new
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param text [String] The text of your direct message, up to 140 characters.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::DirectMessage] The sent message.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Send a direct message to @sferik from the authenticating user
    #   Twitter.direct_message_create('sferik', "I'm sending you this message via @gem!")
    #   Twitter.direct_message_create(7505382, "I'm sending you this message via @gem!")  # Same as above
    def direct_message_create(user, text, options={})
      options.merge_user!(user)
      direct_message = post("/1/direct_messages/new.json", options.merge(:text => text))
      Twitter::DirectMessage.new(direct_message)
    end
    alias :d :direct_message_create

    # Returns a single direct message, specified by id.
    #
    # @see https://dev.twitter.com/docs/api/1/get/direct_messages/show/%3Aid
    # @note This method requires an access token with RWD (read, write & direct message) permissions. Consult The Application Permission Model for more information.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The ID of the direct message to retrieve.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::DirectMessage] The requested message.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the direct message with the id 1825786345
    #   Twitter.direct_message(1825786345)
    def direct_message(id, options={})
      direct_message = get("/1/direct_messages/show/#{id}.json", options)
      Twitter::DirectMessage.new(direct_message)
    end

    # @see https://dev.twitter.com/docs/api/1/get/favorites
    # @rate_limited Yes
    # @requires_authentication No
    # @overload favorites(options={})
    #   Returns the 20 most recent favorite statuses for the authenticating user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @return [Array<Twitter::Status>] favorite statuses.
    #   @example Return the 20 most recent favorite statuses for the authenticating user
    #     Twitter.favorites
    # @overload favorites(user, options={})
    #   Returns the 20 most recent favorite statuses for the specified user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @return [Array<Twitter::Status>] favorite statuses.
    #   @example Return the 20 most recent favorite statuses for @sferik
    #     Twitter.favorites('sferik')
    def favorites(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      if user = args.pop
        get("/1/favorites/#{user}.json", options)
      else
        get("/1/favorites.json", options)
      end.map do |status|
        Twitter::Status.new(status)
      end
    end

    # Favorites the specified status as the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/favorites/create/:id
    # @rate_limited No
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Status] The favorited status.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Favorite the status with the ID 25938088801
    #   Twitter.favorite(25938088801)
    def favorite(id, options={})
      status = post("/1/favorites/create/#{id}.json", options)
      Twitter::Status.new(status)
    end
    alias :favorite_create :favorite

    # Un-favorites the specified status as the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/favorites/destroy/:id
    # @rate_limited No
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Status] The un-favorited status.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Un-favorite the status with the ID 25938088801
    #   Twitter.unfavorite(25938088801)
    def unfavorite(id, options={})
      status = delete("/1/favorites/destroy/#{id}.json", options)
      Twitter::Status.new(status)
    end
    alias :favorite_destroy :unfavorite

    # @see https://dev.twitter.com/docs/api/1/get/followers/ids
    # @rate_limited Yes
    # @requires_authentication No unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @overload follower_ids(options={})
    #   Returns an array of numeric IDs for every user following the authenticated user
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @example Return the authenticated user's followers' IDs
    #     Twitter.follower_ids
    # @overload follower_ids(user, options={})
    #   Returns an array of numeric IDs for every user following the specified user
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @example Return @sferik's followers' IDs
    #     Twitter.follower_ids('sferik')
    #     Twitter.follower_ids(7505382)  # Same as above
    def follower_ids(*args)
      options = {:cursor => -1}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop
      options.merge_user!(user)
      cursor = get("/1/followers/ids.json", options)
      Twitter::Cursor.new(cursor, 'ids')
    end

    # @see https://dev.twitter.com/docs/api/1/get/friends/ids
    # @rate_limited Yes
    # @requires_authentication No unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @overload friend_ids(options={})
    #   Returns an array of numeric IDs for every user the authenticated user is following
    #
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. This is recommended for users who are following many users. Provide a value of -1 to begin paging. Provide values as returned in the response body's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @example Return the authenticated user's friends' IDs
    #     Twitter.friend_ids
    # @overload friend_ids(user, options={})
    #   Returns an array of numeric IDs for every user the specified user is following
    #
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @example Return @sferik's friends' IDs
    #     Twitter.friend_ids('sferik')
    #     Twitter.friend_ids(7505382)  # Same as above
    def friend_ids(*args)
      options = {:cursor => -1}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop
      options.merge_user!(user)
      cursor = get("/1/friends/ids.json", options)
      Twitter::Cursor.new(cursor, 'ids')
    end

    # Test for the existence of friendship between two users
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/exists
    # @note Consider using {Twitter::Client::FriendsAndFollowers#friendship} instead of this method.
    # @rate_limited Yes
    # @requires_authentication No unless user_a or user_b is protected
    # @param user_a [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the subject user.
    # @param user_b [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the user to test for following.
    # @param options [Hash] A customizable set of options.
    # @return [Boolean] true if user_a follows user_b, otherwise false.
    # @example Return true if @sferik follows @pengwynn
    #   Twitter.friendship?('sferik', 'pengwynn')
    #   Twitter.friendship?('sferik', 14100886)   # Same as above
    #   Twitter.friendship?(7505382, 14100886)    # Same as above
    def friendship?(user_a, user_b, options={})
      options.merge_user!(user_a, nil, "a")
      options.merge_user!(user_b, nil, "b")
      get("/1/friendships/exists.json", options)
    end

    # Returns an array of numeric IDs for every user who has a pending request to follow the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/incoming
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    # @return [Twitter::Cursor]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return an array of numeric IDs for every user who has a pending request to follow the authenticating user
    #   Twitter.friendships_incoming
    def friendships_incoming(options={})
      options = {:cursor => -1}.merge(options)
      cursor = get("/1/friendships/incoming.json", options)
      Twitter::Cursor.new(cursor, 'ids')
    end

    # Returns an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/outgoing
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    # @return [Twitter::Cursor]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return an array of numeric IDs for every protected user for whom the authenticating user has a pending follow request
    #   Twitter.friendships_outgoing
    def friendships_outgoing(options={})
      options = {:cursor => -1}.merge(options)
      cursor = get("/1/friendships/outgoing.json", options)
      Twitter::Cursor.new(cursor, 'ids')
    end

    # Returns detailed information about the relationship between two users
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/show
    # @rate_limited Yes
    # @requires_authentication No
    # @param source [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the source user.
    # @param target [Integer, String, Twitter::User] The Twitter user ID, screen name, or object of the target user.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Relationship]
    # @example Return the relationship between @sferik and @pengwynn
    #   Twitter.friendship('sferik', 'pengwynn')
    #   Twitter.friendship('sferik', 14100886)   # Same as above
    #   Twitter.friendship(7505382, 14100886)    # Same as above
    def friendship(source, target, options={})
      options.merge_user!(source, "source")
      options[:source_id] = options.delete(:source_user_id) unless options[:source_user_id].nil?
      options.merge_user!(target, "target")
      options[:target_id] = options.delete(:target_user_id) unless options[:target_user_id].nil?
      relationship = get("/1/friendships/show.json", options)['relationship']
      Twitter::Relationship.new(relationship)
    end
    alias :friendship_show :friendship
    alias :relationship :friendship

    # Allows the authenticating user to follow the specified user
    #
    # @see https://dev.twitter.com/docs/api/1/post/friendships/create
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :follow (false) Enable notifications for the target user.
    # @return [Twitter::User] The followed user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Follow @sferik
    #   Twitter.follow('sferik')
    def follow(user, options={})
      options.merge_user!(user)
      # Twitter always turns on notifications if the "follow" option is present, even if it's set to false
      # so only send follow if it's true
      options.merge!(:follow => true) if options.delete(:follow)
      user = post("/1/friendships/create.json", options)
      Twitter::User.new(user)
    end
    alias :friendship_create :follow

    # Allows the authenticating user to unfollow the specified user
    #
    # @see https://dev.twitter.com/docs/api/1/post/friendships/destroy
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The unfollowed user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Unfollow @sferik
    #   Twitter.unfollow('sferik')
    def unfollow(user, options={})
      options.merge_user!(user)
      user = delete("/1/friendships/destroy.json", options)
      Twitter::User.new(user)
    end
    alias :friendship_destroy :unfollow

    # Returns the relationship of the authenticating user to the comma separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/lookup
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Relationship]
    # @overload friendships(*users, options={})
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @return [Array<Twitter::User>] The requested users.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return extended information for @sferik and @pengwynn
    #     Twitter.friendships('sferik', 'pengwynn')
    #     Twitter.friendships('sferik', 14100886)   # Same as above
    #     Twitter.friendships(7505382, 14100886)    # Same as above
    def friendships(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      users = args
      options.merge_users!(Array(users))
      get("/1/friendships/lookup.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

    # Allows one to enable or disable retweets and device notifications from the specified user.
    #
    # @see https://dev.twitter.com/docs/api/1/post/friendships/update
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :device Enable/disable device notifications from the target user.
    # @option options [Boolean] :retweets Enable/disable retweets from the target user.
    # @return [Twitter::Relationship]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Enable rewteets and devise notifications for @sferik
    #   Twitter.friendship_update('sferik', :device => true, :retweets => true)
    def friendship_update(user, options={})
      options.merge_user!(user)
      relationship = post("/1/friendships/update.json", options)['relationship']
      Twitter::Relationship.new(relationship)
    end

    # Returns an array of user_ids that the currently authenticated user does not want to see retweets from.
    #
    # @see https://dev.twitter.com/docs/api/1/get/friendships/no_retweet_ids
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :stringify_ids Many programming environments will not consume our ids due to their size. Provide this option to have ids returned as strings instead. Read more about Twitter IDs, JSON and Snowflake.
    # @return [Array<Integer>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Enable rewteets and devise notifications for @sferik
    #   Twitter.no_retweet_ids
    def no_retweet_ids(options={})
      get("/1/friendships/no_retweet_ids.json", options)
    end

    # Allows the authenticating user to accept the specified user's follow request
    #
    # @note Undocumented
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The accepted user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Accept @sferik's follow request
    #   Twitter.accept('sferik')
    def accept(user, options={})
      options.merge_user!(user)
      user = post("/1/friendships/accept.json", options)
      Twitter::User.new(user)
    end

    # Allows the authenticating user to deny the specified user's follow request
    #
    # @note Undocumented
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The denied user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Deny @sferik's follow request
    #   Twitter.deny('sferik')
    def deny(user, options={})
      options.merge_user!(user)
      user = post("/1/friendships/deny.json", options)
      Twitter::User.new(user)
    end

    # Returns the current configuration used by Twitter
    #
    # @see https://dev.twitter.com/docs/api/1/get/help/configuration
    # @rate_limited Yes
    # @requires_authentication No
    # @return [Twitter::Configuration] Twitter's configuration.
    # @example Return the current configuration used by Twitter
    #   Twitter.configuration
    def configuration(options={})
      configuration = get("/1/help/configuration.json", options)
      Twitter::Configuration.new(configuration)
    end

    # Returns the list of languages supported by Twitter
    #
    # @see https://dev.twitter.com/docs/api/1/get/help/languages
    # @rate_limited Yes
    # @requires_authentication No
    # @return [Array<Twitter::Language>]
    # @example Return the list of languages Twitter supports
    #   Twitter.languages
    def languages(options={})
      get("/1/help/languages.json", options).map do |language|
        Twitter::Language.new(language)
      end
    end

    # Returns {https://twitter.com/privacy Twitter's Privacy Policy}
    #
    # @see https://dev.twitter.com/docs/api/1/get/legal/privacy
    # @rate_limited Yes
    # @requires_authentication No
    # @return [String]
    # @example Return {https://twitter.com/privacy Twitter's Privacy Policy}
    #   Twitter.privacy
    def privacy(options={})
      get("/1/legal/privacy.json", options)['privacy']
    end

    # Returns {https://twitter.com/tos Twitter's Terms of Service}
    #
    # @see https://dev.twitter.com/docs/api/1/get/legal/tos
    # @rate_limited Yes
    # @requires_authentication No
    # @return [String]
    # @example Return {https://twitter.com/tos Twitter's Terms of Service}
    #   Twitter.tos
    def tos(options={})
      get("/1/legal/tos.json", options)['tos']
    end

    # Returns all lists the authenticating or specified user subscribes to, including their own
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/all
    # @rate_limited Yes
    # @requires_authentication Supported
    # @overload lists_subscribed_to(options={})
    #   @param options [Hash] A customizable set of options.
    #   @return [Array<Twitter::Status>]
    #   @example Return all lists the authenticating user subscribes to
    #     Twitter.lists_subscribed_to
    # @overload lists_subscribed_to(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Array<Twitter::List>]
    #   @example Return all lists the specified user subscribes to
    #     Twitter.lists_subscribed_to('sferik')
    #     Twitter.lists_subscribed_to(8863586)
    def lists_subscribed_to(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      if user = args.pop
        options.merge_user!(user)
      end
      get("/1/lists/all.json", options).map do |list|
        Twitter::List.new(list)
      end
    end

    # Show tweet timeline for members of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/statuses
    # @rate_limited Yes
    # @requires_authentication No
    # @overload list_timeline(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :per_page The number of results to retrieve.
    #   @return [Array<Twitter::Status>]
    #   @example Show tweet timeline for members of the authenticated user's "presidents" list
    #     Twitter.list_timeline('presidents')
    #     Twitter.list_timeline(8863586)
    # @overload list_timeline(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :per_page The number of results to retrieve.
    #   @return [Array<Twitter::Status>]
    #   @example Show tweet timeline for members of @sferik's "presidents" list
    #     Twitter.list_timeline('sferik', 'presidents')
    #     Twitter.list_timeline('sferik', 8863586)
    #     Twitter.list_timeline(7505382, 'presidents')
    #     Twitter.list_timeline(7505382, 8863586)
    def list_timeline(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      get("/1/lists/statuses.json", options).map do |status|
        Twitter::Status.new(status)
      end
    end

    # Removes the specified member from the list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/members/destroy
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_remove_member(list, user_to_remove, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Remove @BarackObama from the authenticated user's "presidents" list
    #     Twitter.list_remove_member('presidents', 813286)
    #     Twitter.list_remove_member('presidents', 'BarackObama')
    #     Twitter.list_remove_member(8863586, 'BarackObama')
    # @overload list_remove_member(user, list, user_to_remove, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_remove [Integer, String] The user id or screen name of the list member to remove.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Remove @BarackObama from @sferik's "presidents" list
    #     Twitter.list_remove_member('sferik', 'presidents', 813286)
    #     Twitter.list_remove_member('sferik', 'presidents', 'BarackObama')
    #     Twitter.list_remove_member('sferik', 8863586, 'BarackObama')
    #     Twitter.list_remove_member(7505382, 'presidents', 813286)
    def list_remove_member(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      user_to_remove = args.pop
      options.merge_user!(user_to_remove)
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/members/destroy.json", options)
      Twitter::List.new(list)
    end

    # List the lists the specified user has been added to
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/memberships
    # @rate_limited Yes
    # @requires_authentication Supported
    # @overload memberships(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List the lists the authenticated user has been added to
    #     Twitter.memberships
    # @overload memberships(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List the lists that @sferik has been added to
    #     Twitter.memberships('sferik')
    #     Twitter.memberships(7505382)
    def memberships(*args)
      options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
      if user = args.pop
        options.merge_user!(user)
      end
      cursor = get("/1/lists/memberships.json", options)
      Twitter::Cursor.new(cursor, 'lists', Twitter::List)
    end

    # Returns the subscribers of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers
    # @rate_limited Yes
    # @requires_authentication Supported
    # @overload list_subscribers(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor] The subscribers of the specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the subscribers of the authenticated user's "presidents" list
    #     Twitter.list_subscribers('presidents')
    #     Twitter.list_subscribers(8863586)
    # @overload list_subscribers(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor] The subscribers of the specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the subscribers of @sferik's "presidents" list
    #     Twitter.list_subscribers('sferik', 'presidents')
    #     Twitter.list_subscribers('sferik', 8863586)
    #     Twitter.list_subscribers(7505382, 'presidents')
    def list_subscribers(*args)
      options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      cursor = get("/1/lists/subscribers.json", options)
      Twitter::Cursor.new(cursor, 'users', Twitter::User)
    end

    # List the lists the specified user follows
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/subscriptions
    # @rate_limited Yes
    # @requires_authentication Supported
    # @overload subscriptions(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List the lists the authenticated user follows
    #     Twitter.subscriptions
    # @overload subscriptions(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List the lists that @sferik follows
    #     Twitter.subscriptions('sferik')
    #     Twitter.subscriptions(7505382)
    def subscriptions(*args)
      options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
      if user = args.pop
        options.merge_user!(user)
      end
      cursor = get("/1/lists/subscriptions.json", options)
      Twitter::Cursor.new(cursor, 'lists', Twitter::List)
    end

    # Make the authenticated user follow the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/create
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_subscribe(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Subscribe to the authenticated user's "presidents" list
    #     Twitter.list_subscribe('presidents')
    #     Twitter.list_subscribe(8863586)
    # @overload list_subscribe(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Subscribe to @sferik's "presidents" list
    #     Twitter.list_subscribe('sferik', 'presidents')
    #     Twitter.list_subscribe('sferik', 8863586)
    #     Twitter.list_subscribe(7505382, 'presidents')
    def list_subscribe(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/subscribers/create.json", options)
      Twitter::List.new(list)
    end

    # Check if a user is a subscriber of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/subscribers/show
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload list_subscriber?(list, user_to_check, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Check if @BarackObama is a subscriber of the authenticated user's "presidents" list
    #     Twitter.list_subscriber?('presidents', 813286)
    #     Twitter.list_subscriber?(8863586, 813286)
    #     Twitter.list_subscriber?('presidents', 'BarackObama')
    # @overload list_subscriber?(user, list, user_to_check, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Check if @BarackObama is a subscriber of @sferik's "presidents" list
    #     Twitter.list_subscriber?('sferik', 'presidents', 813286)
    #     Twitter.list_subscriber?('sferik', 8863586, 813286)
    #     Twitter.list_subscriber?(7505382, 'presidents', 813286)
    #     Twitter.list_subscriber?('sferik', 'presidents', 'BarackObama')
    # @return [Boolean] true if user is a subscriber of the specified list, otherwise false.
    def list_subscriber?(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      user_to_check = args.pop
      options.merge_user!(user_to_check)
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      get("/1/lists/subscribers/show.json", options, :raw => true)
      true
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      false
    end

    # Unsubscribes the authenticated user form the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/subscribers/destroy
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_unsubscribe(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Unsubscribe from the authenticated user's "presidents" list
    #     Twitter.list_unsubscribe('presidents')
    #     Twitter.list_unsubscribe(8863586)
    # @overload list_unsubscribe(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Unsubscribe from @sferik's "presidents" list
    #     Twitter.list_unsubscribe('sferik', 'presidents')
    #     Twitter.list_unsubscribe('sferik', 8863586)
    #     Twitter.list_unsubscribe(7505382, 'presidents')
    def list_unsubscribe(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/subscribers/destroy.json", options)
      Twitter::List.new(list)
    end

    # Adds specified members to a list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/members/create_all
    # @note Lists are limited to having 500 members, and you are limited to adding up to 100 members to a list at a time with this method.
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_add_members(list, users, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
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
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Add @BarackObama and @pengwynn to @sferik's "presidents" list
    #     Twitter.list_add_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members('sferik', 'presidents', [813286, 18755393])
    #     Twitter.list_add_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members(7505382, 'presidents', [813286, 18755393])
    #     Twitter.list_add_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_add_members(7505382, 8863586, [813286, 18755393])
    def list_add_members(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      users = args.pop
      options.merge_users!(Array(users))
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/members/create_all.json", options)
      Twitter::List.new(list)
    end

    # Removes specified members from the list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/members/destroy_all
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_remove_members(list, users, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
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
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Remove @BarackObama and @pengwynn from @sferik's "presidents" list
    #     Twitter.list_remove_members('sferik', 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members('sferik', 'presidents', [813286, 18755393])
    #     Twitter.list_remove_members(7505382, 'presidents', ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members(7505382, 'presidents', [813286, 18755393])
    #     Twitter.list_remove_members(7505382, 8863586, ['BarackObama', 'pengwynn'])
    #     Twitter.list_remove_members(7505382, 8863586, [813286, 18755393])
    def list_remove_members(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      users = args.pop
      options.merge_users!(Array(users))
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/members/destroy_all.json", options)
      Twitter::List.new(list)
    end

    # Check if a user is a member of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/members/show
    # @requires_authentication Yes
    # @rate_limited Yes
    # @overload list_member?(list, user_to_check, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
    #   @param options [Hash] A customizable set of options.
    #   @return [Boolean] true if user is a member of the specified list, otherwise false.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Check if @BarackObama is a member of the authenticated user's "presidents" list
    #     Twitter.list_member?('presidents', 813286)
    #     Twitter.list_member?(8863586, 'BarackObama')
    # @overload list_member?(user, list, user_to_check, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_check [Integer, String] The user ID or screen name of the list member.
    #   @param options [Hash] A customizable set of options.
    #   @return [Boolean] true if user is a member of the specified list, otherwise false.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Check if @BarackObama is a member of @sferik's "presidents" list
    #     Twitter.list_member?('sferik', 'presidents', 813286)
    #     Twitter.list_member?('sferik', 8863586, 'BarackObama')
    #     Twitter.list_member?(7505382, 'presidents', 813286)
    def list_member?(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      user_to_check = args.pop
      options.merge_user!(user_to_check)
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      get("/1/lists/members/show.json", options, :raw => true)
      true
    rescue Twitter::Error::NotFound, Twitter::Error::Forbidden
      false
    end

    # Returns the members of the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/members
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload list_members(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the members of the authenticated user's "presidents" list
    #     Twitter.list_members('presidents')
    #     Twitter.list_members(8863586)
    # @overload list_members(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the members of @sferik's "presidents" list
    #     Twitter.list_members('sferik', 'presidents')
    #     Twitter.list_members('sferik', 8863586)
    #     Twitter.list_members(7505382, 'presidents')
    #     Twitter.list_members(7505382, 8863586)
    def list_members(*args)
      options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      cursor = get("/1/lists/members.json", options)
      Twitter::Cursor.new(cursor, 'users', Twitter::User)
    end

    # Add a member to a list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/members/create
    # @note Lists are limited to having 500 members.
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_add_member(list, user_to_add, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Add @BarackObama to the authenticated user's "presidents" list
    #     Twitter.list_add_member('presidents', 813286)
    #     Twitter.list_add_member(8863586, 813286)
    # @overload list_add_member(user, list, user_to_add, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param user_to_add [Integer, String] The user id or screen name to add to the list.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Add @BarackObama to @sferik's "presidents" list
    #     Twitter.list_add_member('sferik', 'presidents', 813286)
    #     Twitter.list_add_member('sferik', 8863586, 813286)
    #     Twitter.list_add_member(7505382, 'presidents', 813286)
    #     Twitter.list_add_member(7505382, 8863586, 813286)
    def list_add_member(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      user_to_add = args.pop
      options.merge_user!(user_to_add)
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/members/create.json", options)
      Twitter::List.new(list)
    end

    # Deletes the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/destroy
    # @note Must be owned by the authenticated user.
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_destroy(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The deleted list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Delete the authenticated user's "presidents" list
    #     Twitter.list_destroy('presidents')
    #     Twitter.list_destroy(8863586)
    # @overload list_destroy(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The deleted list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Delete @sferik's "presidents" list
    #     Twitter.list_destroy('sferik', 'presidents')
    #     Twitter.list_destroy('sferik', 8863586)
    #     Twitter.list_destroy(7505382, 'presidents')
    #     Twitter.list_destroy(7505382, 8863586)
    def list_destroy(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = delete("/1/lists/destroy.json", options)
      Twitter::List.new(list)
    end

    # Updates the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/update
    # @rate_limited No
    # @requires_authentication Yes
    # @overload list_update(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    #   @option options [String] :description The description to give the list.
    #   @return [Twitter::List] The created list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Update the authenticated user's "presidents" list to have the description "Presidents of the United States of America"
    #     Twitter.list_update('presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update(8863586, :description => "Presidents of the United States of America")
    # @overload list_update(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    #   @option options [String] :description The description to give the list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @return [Twitter::List] The created list.
    #   @example Update the @sferik's "presidents" list to have the description "Presidents of the United States of America"
    #     Twitter.list_update('sferik', 'presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update(7505382, 'presidents', :description => "Presidents of the United States of America")
    #     Twitter.list_update('sferik', 8863586, :description => "Presidents of the United States of America")
    #     Twitter.list_update(7505382, 8863586, :description => "Presidents of the United States of America")
    def list_update(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = post("/1/lists/update.json", options)
      Twitter::List.new(list)
    end

    # Creates a new list for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1/post/lists/create
    # @note Accounts are limited to 20 lists.
    # @rate_limited No
    # @requires_authentication Yes
    # @param name [String] The name for the list.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :mode ('public') Whether your list is public or private. Values can be 'public' or 'private'.
    # @option options [String] :description The description to give the list.
    # @return [Twitter::List] The created list.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Create a list named 'presidents'
    #   Twitter.list_create('presidents')
    def list_create(name, options={})
      list = post("/1/lists/create.json", options.merge(:name => name))
      Twitter::List.new(list)
    end

    # List the lists of the specified user
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists
    # @note Private lists will be included if the authenticated user is the same as the user whose lists are being returned.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload lists(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List the authenticated user's lists
    #     Twitter.lists
    # @overload lists(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :cursor (-1) Breaks the results into pages. Provide values as returned in the response objects's next_cursor and previous_cursor attributes to page back and forth in the list.
    #   @return [Twitter::Cursor]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example List @sferik's lists
    #     Twitter.lists('sferik')
    #     Twitter.lists(7505382)
    def lists(*args)
      options = {:cursor => -1}.merge(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop
      options.merge_user!(user) if user
      cursor = get("/1/lists.json", options)
      Twitter::Cursor.new(cursor, 'lists', Twitter::List)
    end

    # Show the specified list
    #
    # @see https://dev.twitter.com/docs/api/1/get/lists/show
    # @note Private lists will only be shown if the authenticated user owns the specified list.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload list(list, options={})
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Show the authenticated user's "presidents" list
    #     Twitter.list('presidents')
    #     Twitter.list(8863586)
    # @overload list(user, list, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param list [Integer, String, Twitter::List] A Twitter list ID, slug, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::List] The specified list.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Show @sferik's "presidents" list
    #     Twitter.list('sferik', 'presidents')
    #     Twitter.list('sferik', 8863586)
    #     Twitter.list(7505382, 'presidents')
    #     Twitter.list(7505382, 8863586)
    def list(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      list = args.pop
      options.merge_list!(list)
      unless options[:owner_id] || options[:owner_screen_name]
        owner = args.pop || self.current_user.screen_name
        options.merge_owner!(owner)
      end
      list = get("/1/lists/show.json", options)
      Twitter::List.new(list)
    end

    # Returns the top 10 trending topics for a specific WOEID
    #
    # @see https://dev.twitter.com/docs/api/1/get/trends/:woeid
    # @rate_limited Yes
    # @requires_authentication No
    # @param woeid [Integer] The {https://developer.yahoo.com/geo/geoplanet Yahoo! Where On Earth ID} of the location to return trending information for. WOEIDs can be retrieved by calling {Twitter::Client::LocalTrends#trend_locations}. Global information is available by using 1 as the WOEID.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
    # @return [Array<Twitter::Trend>]
    # @example Return the top 10 trending topics for San Francisco
    #   Twitter.local_trends(2487956)
    def local_trends(woeid=1, options={})
      get("/1/trends/#{woeid}.json", options).first['trends'].map do |trend|
        Twitter::Trend.new(trend)
      end
    end
    alias :trends :local_trends

    # Returns the locations that Twitter has trending topic information for
    #
    # @see https://dev.twitter.com/docs/api/1/get/trends/available
    # @rate_limited Yes
    # @requires_authentication No
    # @param options [Hash] A customizable set of options.
    # @option options [Float] :lat If provided with a :long option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for latitude are -90.0 to +90.0 (North is positive) inclusive.
    # @option options [Float] :long If provided with a :lat option the available trend locations will be sorted by distance, nearest to furthest, to the co-ordinate pair. The valid ranges for longitude are -180.0 to +180.0 (East is positive) inclusive.
    # @return [Array<Twitter::Place>]
    # @example Return the locations that Twitter has trending topic information for
    #   Twitter.trend_locations
    def trend_locations(options={})
      get("/1/trends/available.json", options).map do |place|
        Twitter::Place.new(place)
      end
    end

    # Enables device notifications for updates from the specified user to the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/notifications/follow
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The specified user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Enable device notifications for updates from @sferik
    #   Twitter.enable_notifications('sferik')
    #   Twitter.enable_notifications(7505382)  # Same as above
    def enable_notifications(user, options={})
      options.merge_user!(user)
      user = post("/1/notifications/follow.json", options)
      Twitter::User.new(user)
    end

    # Disables notifications for updates from the specified user to the authenticating user
    #
    # @see https://dev.twitter.com/docs/api/1/post/notifications/leave
    # @rate_limited No
    # @requires_authentication Yes
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The specified user.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Disable device notifications for updates from @sferik
    #   Twitter.disable_notifications('sferik')
    #   Twitter.disable_notifications(7505382)  # Same as above
    def disable_notifications(user, options={})
      options.merge_user!(user)
      user = post("/1/notifications/leave.json", options)
      Twitter::User.new(user)
    end

    # Search for places that can be attached to a {Twitter::Client::Tweets#update}
    #
    # @see https://dev.twitter.com/docs/api/1/get/geo/search
    # @rate_limited Yes
    # @requires_authentication No
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
      get("/1/geo/search.json", options)['result']['places'].map do |place|
        Twitter::Place.new(place)
      end
    end
    alias :geo_search :places_nearby

    # Locates places near the given coordinates which are similar in name
    #
    # @see https://dev.twitter.com/docs/api/1/get/geo/similar_places
    # @note Conceptually, you would use this method to get a list of known places to choose from first. Then, if the desired place doesn't exist, make a request to {Twitter::Client::Geo#place} to create a new one. The token contained in the response is the token necessary to create a new place.
    # @rate_limited Yes
    # @requires_authentication No
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
      get("/1/geo/similar_places.json", options)['result']['places'].map do |place|
        Twitter::Place.new(place)
      end
    end

    # Searches for up to 20 places that can be used as a place_id
    #
    # @see https://dev.twitter.com/docs/api/1/get/geo/reverse_geocode
    # @note This request is an informative call and will deliver generalized results about geography.
    # @rate_limited Yes
    # @requires_authentication No
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
      get("/1/geo/reverse_geocode.json", options)['result']['places'].map do |place|
        Twitter::Place.new(place)
      end
    end

    # Returns all the information about a known place
    #
    # @see https://dev.twitter.com/docs/api/1/get/geo/id/:place_id
    # @rate_limited Yes
    # @requires_authentication No
    # @param place_id [String] A place in the world. These IDs can be retrieved from {Twitter::Client::Geo#reverse_geocode}.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Place] The requested place.
    # @example Return all the information about Twitter HQ
    #   Twitter.place("247f43d441defc03")
    def place(place_id, options={})
      place = get("/1/geo/id/#{place_id}.json", options)
      Twitter::Place.new(place)
    end

    # Creates a new place at the given latitude and longitude
    #
    # @see https://dev.twitter.com/docs/api/1/post/geo/place
    # @rate_limited Yes
    # @requires_authentication No
    # @param options [Hash] A customizable set of options.
    # @option options [String] :name The name a place is known as.
    # @option options [String] :contained_within This is the place_id which you would like to restrict the search results to. Setting this value means only places within the given place_id will be found.
    # @option options [String] :token The token found in the response from {Twitter::Client::Geo#places_similar}.
    # @option options [Float] :lat The latitude to search around. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude to search around. The valid range for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :"attribute:street_address" This option searches for places which have this given street address. There are other well-known and application-specific attributes available. Custom attributes are also permitted.
    # @return [Twitter::Place] The created place.
    # @example Create a new place
    #   Twitter.place_create(:name => "@sferik's Apartment", :token => "22ff5b1f7159032cf69218c4d8bb78bc", :contained_within => "41bcb736f84a799e", :lat => "37.783699", :long => "-122.393581")
    def place_create(options={})
      place = post("/1/geo/place.json", options)
      Twitter::Place.new(place)
    end

    # Returns the authenticated user's saved search queries
    #
    # @see https://dev.twitter.com/docs/api/1/get/saved_searches
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @return [Array<Twitter::SavedSearch>] Saved search queries.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the authenticated user's saved search queries
    #   Twitter.saved_searches
    def saved_searches(options={})
      get("/1/saved_searches.json", options).map do |saved_search|
        Twitter::SavedSearch.new(saved_search)
      end
    end

    # Retrieve the data for a saved search owned by the authenticating user specified by the given ID
    #
    # @see https://dev.twitter.com/docs/api/1/get/saved_searches/show/:id
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The ID of the saved search.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::SavedSearch] The saved search.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Retrieve the data for a saved search owned by the authenticating user with the ID 16129012
    #   Twitter.saved_search(16129012)
    def saved_search(id, options={})
      saved_search = get("/1/saved_searches/show/#{id}.json", options)
      Twitter::SavedSearch.new(saved_search)
    end

    # Creates a saved search for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1/post/saved_searches/create
    # @rate_limited No
    # @requires_authentication Yes
    # @param query [String] The query of the search the user would like to save.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::SavedSearch] The created saved search.
    # @example Create a saved search for the authenticated user with the query "twitter"
    #   Twitter.saved_search_create("twitter")
    def saved_search_create(query, options={})
      saved_search = post("/1/saved_searches/create.json", options.merge(:query => query))
      Twitter::SavedSearch.new(saved_search)
    end

    # Destroys a saved search for the authenticated user
    #
    # @see https://dev.twitter.com/docs/api/1/post/saved_searches/destroy/:id
    # @note The search specified by ID must be owned by the authenticating user.
    # @rate_limited No
    # @requires_authentication Yes
    # @param id [Integer] The ID of the saved search.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::SavedSearch] The deleted saved search.
    # @example Destroys a saved search for the authenticated user with the ID 16129012
    #   Twitter.saved_search_destroy(16129012)
    def saved_search_destroy(id, options={})
      saved_search = delete("/1/saved_searches/destroy/#{id}.json", options)
      Twitter::SavedSearch.new(saved_search)
    end

    # Returns tweets that match a specified query.
    #
    # @see https://dev.twitter.com/docs/api/1/get/search
    # @see https://dev.twitter.com/docs/using-search
    # @see https://dev.twitter.com/docs/history-rest-search-api
    # @note As of April 1st 2010, the Search API provides an option to retrieve "popular tweets" in addition to real-time search results. In an upcoming release, this will become the default and clients that don't want to receive popular tweets in their search results will have to explicitly opt-out. See the result_type parameter below for more information.
    # @rate_limited Yes
    # @requires_authentication No
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :geocode Returns tweets by users located within a given radius of the given latitude/longitude. The location is preferentially taking from the Geotagging API, but will fall back to their Twitter profile. The parameter value is specified by "latitude,longitude,radius", where radius units must be specified as either "mi" (miles) or "km" (kilometers). Note that you cannot use the near operator via the API to geocode arbitrary locations; however you can use this geocode parameter to search near geocodes directly.
    # @option options [String] :lang Restricts tweets to the given language, given by an ISO 639-1 code.
    # @option options [String] :locale Specify the language of the query you are sending (only ja is currently effective). This is intended for language-specific clients and the default should work in the majority of cases.
    # @option options [Integer] :page The page number (starting at 1) to return, up to a max of roughly 1500 results (based on rpp * page).
    # @option options [String] :result_type Specifies what type of search results you would prefer to receive. Options are "mixed", "recent", and "popular". The current default is "mixed."
    # @option options [Integer] :rpp The number of tweets to return per page, up to a max of 100.
    # @option options [String] :until Optional. Returns tweets generated before the given date. Date should be formatted as YYYY-MM-DD.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID. There are limits to the number of Tweets which can be accessed through the API. If the limit of Tweets has occured since the since_id, the since_id will be forced to the oldest ID available.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Boolean, String, Integer] :with_twitter_user_id When set to either true, t or 1, the from_user_id and to_user_id values in the response will map to "official" user IDs which will match those returned by the REST API.
    # @return [Twitter::SearchResults] Return tweets that match a specified query with search metadata
    # @example Returns tweets related to twitter
    #   Twitter.search('twitter')
    def search(q, options={})
      response = get("/search.json", options.merge(:q => q), :endpoint => search_endpoint)
      Twitter::SearchResults.new(response)
    end

    # Returns recent statuses related to a query with images and videos embedded
    #
    # @note Undocumented
    # @rate_limited Yes
    # @requires_authentication No
    # @param q [String] A search term.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @return [Array<Twitter::Status>] An array of statuses that contain videos
    # @example Return recent statuses related to twitter with images and videos embedded
    #   Twitter.phoenix_search('twitter')
    def phoenix_search(q, options={})
      get("/phoenix_search.phoenix", options.merge(:q => q))['statuses'].map do |status|
        Twitter::Status.new(status)
      end
    end

    # The user specified is blocked by the authenticated user and reported as a spammer
    #
    # @see https://dev.twitter.com/docs/api/1/post/report_spam
    # @rate_limited Yes
    # @requires_authentication No
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::User] The reported user.
    # @example Report @spam for spam
    #   Twitter.report_spam("spam")
    #   Twitter.report_spam(14589771) # Same as above
    def report_spam(user, options={})
      options.merge_user!(user)
      user = post("/1/report_spam.json", options)
      Twitter::User.new(user)
    end

    # @overload suggestions(options={})
    #   Returns the list of suggested user categories
    #
    #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions
    #   @rate_limited Yes
    #   @requires_authentication No
    #   @param options [Hash] A customizable set of options.
    #   @return [Array<Twitter::Suggestion>]
    #   @example Return the list of suggested user categories
    #     Twitter.suggestions
    # @overload suggestions(slug, options={})
    #   Returns the users in a given category
    #
    #   @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug
    #   @rate_limited Yes
    #   @requires_authentication No
    #   @param slug [String] The short name of list or a category.
    #   @param options [Hash] A customizable set of options.
    #   @return [Array<Twitter::Suggestion>]
    #   @example Return the users in the Art & Design category
    #     Twitter.suggestions("art-design")
    def suggestions(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      if slug = args.pop
        suggestion = get("/1/users/suggestions/#{slug}.json", options)
        Twitter::Suggestion.new(suggestion)
      else
        get("/1/users/suggestions.json", options).map do |suggestion|
          Twitter::Suggestion.new(suggestion)
        end
      end
    end

    # Access the users in a given category of the Twitter suggested user list and return their most recent status if they are not a protected user
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/suggestions/:slug/members
    # @rate_limited Yes
    # @requires_authentication No
    # @param slug [String] The short name of list or a category.
    # @param options [Hash] A customizable set of options.
    # @return [Array<Twitter::User>]
    # @example Return the users in the Art & Design category and their most recent status if they are not a protected user
    #   Twitter.suggest_users("art-design")
    def suggest_users(slug, options={})
      get("/1/users/suggestions/#{slug}/members.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

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
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
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
    # @note This method can only return up to 800 statuses.
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    # @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Array<Twitter::Status>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the 20 most recent mentions (statuses containing @username) for the authenticating user
    #   Twitter.mentions
    def mentions(options={})
      get("/1/statuses/mentions.json", options).map do |status|
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
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    #   @return [Array<Twitter::Status>]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the 20 most recent retweets posted by the authenticating user
    #     Twitter.retweeted_by('sferik')
    # @overload retweeted_by(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
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
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    #   @return [Array<Twitter::Status>]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
    #     Twitter.retweeted_to
    # @overload retweeted_to(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    #   @return [Array<Twitter::Status>]
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return the 20 most recent retweets posted by users followed by the authenticating user
    #     Twitter.retweeted_to('sferik')
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
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
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
    # @note This method can only return up to 3200 statuses.
    # @rate_limited Yes
    # @requires_authentication No, unless the user whose timeline you're trying to view is protected
    # @overload user_timeline(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :since_id Returns results with an ID greater than (that is, more recent than) the specified ID.
    #   @option options [Integer] :max_id Returns results with an ID less than (that is, older than) or equal to the specified ID.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    #   @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    #   @return [Array<Twitter::Status>]
    #   @example Return the 20 most recent statuses posted by @sferik
    #     Twitter.user_timeline('sferik')
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
    # @requires_authentication No, unless the user whose timeline you're trying to view is protected
    # @overload media_timeline(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 200.
    #   @option options [Boolean] :filter Include possibly sensitive media when set to false, 'f' or 0.
    #   @return [Array<Twitter::Status>]
    #   @example Return the 20 most recent statuses posted by @sferik
    #     Twitter.media_timeline('sferik')
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
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean, String, Integer] :exclude_replies This parameter will prevent replies from appearing in the returned timeline. Using exclude_replies with the count parameter will mean you will receive up-to count tweets - this is because the count parameter retrieves that many tweets before filtering out retweets and replies.
    # @return [Array<Twitter::Status>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return the 20 most recent statuses from the authenticating user's network
    #   Twitter.network_timeline
    def network_timeline(options={})
      get("/i/statuses/network_timeline.json", options).map do |status|
        Twitter::Status.new(status)
      end
    end

    # Returns the top 20 trending topics for each hour in a given day
    #
    # @see https://dev.twitter.com/docs/api/1/get/trends/daily
    # @rate_limited Yes
    # @requires_authentication No
    # @param date [Date] The start date for the report. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
    # @return [Hash]
    # @example Return the top 20 trending topics for each hour of October 24, 2010
    #   Twitter.trends_daily(Date.parse("2010-10-24"))
    def trends_daily(date=Date.today, options={})
      trends = {}
      get("/1/trends/daily.json", options.merge(:date => date.strftime('%Y-%m-%d')))['trends'].each do |key, value|
        trends[key] = []
        value.each do |trend|
          trends[key] << Twitter::Trend.new(trend)
        end
      end
      trends
    end

    # Returns the top 30 trending topics for each day in a given week
    #
    # @see https://dev.twitter.com/docs/api/1/get/trends/weekly
    # @rate_limited Yes
    # @requires_authentication No
    # @param date [Date] The start date for the report. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
    # @param options [Hash] A customizable set of options.
    # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
    # @return [Hash]
    # @example Return the top ten topics that are currently trending on Twitter
    #   Twitter.trends_weekly(Date.parse("2010-10-24"))
    def trends_weekly(date=Date.today, options={})
      trends = {}
      get("/1/trends/weekly.json", options.merge(:date => date.strftime('%Y-%m-%d')))['trends'].each do |key, value|
        trends[key] = []
        value.each do |trend|
          trends[key] << Twitter::Trend.new(trend)
        end
      end
      trends
    end

    # Show up to 100 users who retweeted the status
    #
    # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by
    # @see https://dev.twitter.com/docs/api/1/get/statuses/:id/retweeted_by/ids
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @option options [Boolean] :ids_only ('false') Only return user ids instead of full user objects.
    # @return [Array]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Show up to 100 users who retweeted the status with the ID 28561922516
    #   Twitter.retweeters_of(28561922516)
    def retweeters_of(id, options={})
      if ids_only = !!options.delete(:ids_only)
        get("/1/statuses/#{id}/retweeted_by/ids.json", options)
      else
        get("/1/statuses/#{id}/retweeted_by.json", options).map do |user|
          Twitter::User.new(user)
        end
      end
    end

    # Returns up to 100 of the first retweets of a given tweet
    #
    # @see https://dev.twitter.com/docs/api/1/get/statuses/retweets/:id
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :count Specifies the number of records to retrieve. Must be less than or equal to 100.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Array<Twitter::Status>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return up to 100 of the first retweets of the status with the ID 28561922516
    #   Twitter.retweets(28561922516)
    def retweets(id, options={})
      get("/1/statuses/retweets/#{id}.json", options).map do |status|
        Twitter::Status.new(status)
      end
    end

    # Returns a single status, specified by ID
    #
    # @see https://dev.twitter.com/docs/api/1/get/statuses/show/:id
    # @rate_limited Yes
    # @requires_authentication No, unless the author of the status is protected
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The requested status.
    # @example Return the status with the ID 25938088801
    #   Twitter.status(25938088801)
    def status(id, options={})
      status = get("/1/statuses/show/#{id}.json", options)
      Twitter::Status.new(status)
    end

    # Returns activity summary for a single status, specified by ID
    #
    # @note Undocumented
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @return [Twitter::Status] The requested status.
    # @example Return activity summary for the status with the ID 25938088801
    #   Twitter.status_activity(25938088801)
    def status_activity(id, options={})
      status = get("/i/statuses/#{id}/activity/summary.json", options)
      status.merge!('id' => id)
      Twitter::Status.new(status)
    end

    # Returns a single status with activity summary, specified by ID
    #
    # @see https://dev.twitter.com/docs/api/1/get/statuses/show/:id
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The requested status.
    # @example Return the status with activity summary with the ID 25938088801
    #   Twitter.status_with_activity(25938088801)
    def status_with_activity(id, options={})
      activity = get("/i/statuses/#{id}/activity/summary.json", options)
      status = get("/1/statuses/show/#{id}.json", options)
      status.merge!(activity)
      Twitter::Status.new(status)
    end

    # Returns an oEmbed version of a single status, specified by ID or url to the tweet
    #
    # @see https://dev.twitter.com/docs/api/1/get/statuses/oembed
    # @rate_limited Yes
    # @requires_authentication No, unless the author of the status is protected
    # @param id [Integer] The numerical ID of the desired status to be embedded.
    # @param url [String] The url to the status to be embedded. ex: https://twitter.com/#!/twitter/status/25938088801
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :maxwidth The maximum width in pixels that the embed should be rendered at. This value is constrained to be between 250 and 550 pixels.
    # @option options [Boolean, String, Integer] :hide_media Specifies whether the embedded Tweet should automatically expand images which were uploaded via {https://dev.twitter.com/docs/api/1/post/statuses/update_with_media POST statuses/update_with_media}. When set to either true, t or 1 images will not be expanded. Defaults to false.
    # @option options [Boolean, String, Integer] :hide_thread Specifies whether the embedded Tweet should automatically show the original message in the case that the embedded Tweet is a reply. When set to either true, t or 1 the original Tweet will not be shown. Defaults to false.
    # @option options [Boolean, String, Integer] :omit_script Specifies whether the embedded Tweet HTML should include a `<script>` element pointing to widgets.js. In cases where a page already includes widgets.js, setting this value to true will prevent a redundant script element from being included. When set to either true, t or 1 the `<script>` element will not be included in the embed HTML, meaning that pages must include a reference to widgets.js manually. Defaults to false.
    # @option options [String] :align Specifies whether the embedded Tweet should be left aligned, right aligned, or centered in the page. Valid values are left, right, center, and none. Defaults to none, meaning no alignment styles are specified for the Tweet.
    # @option options [String] :related A value for the TWT related parameter, as described in {https://dev.twitter.com/docs/intents Web Intents}. This value will be forwarded to all Web Intents calls.
    # @option options [String] :lang Language code for the rendered embed. This will affect the text and localization of the rendered HTML.
    def oembed(id_or_url, options={})
      case id_or_url
      when Integer
        id = id_or_url
        oembed = get("/1/statuses/oembed.json?id=#{id}", options)
      when String
        url = id_or_url
        escaped_url = URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        oembed = get("/1/statuses/oembed.json?url=#{escaped_url}", options)
      end
      Twitter::OEmbed.new(oembed)
    end
    # Destroys the specified status
    #
    # @see https://dev.twitter.com/docs/api/1/post/statuses/destroy/:id
    # @note The authenticating user must be the author of the specified status.
    # @rate_limited No
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The deleted status.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Destroy the status with the ID 25938088801
    #   Twitter.status_destroy(25938088801)
    def status_destroy(id, options={})
      status = delete("/1/statuses/destroy/#{id}.json", options)
      Twitter::Status.new(status)
    end

    # Retweets a tweet
    #
    # @see https://dev.twitter.com/docs/api/1/post/statuses/retweet/:id
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param id [Integer] The numerical ID of the desired status.
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The original tweet with retweet details embedded.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Retweet the status with the ID 28561922516
    #   Twitter.retweet(28561922516)
    def retweet(id, options={})
      new_status = post("/1/statuses/retweet/#{id}.json", options)
      orig_status = new_status.delete('retweeted_status')
      orig_status['retweeted_status'] = new_status
      Twitter::Status.new(orig_status)
    end

    # Updates the authenticating user's status
    #
    # @see https://dev.twitter.com/docs/api/1/post/statuses/update
    # @note A status update with text identical to the authenticating user's current status will be ignored to prevent duplicates.
    # @rate_limited No
    # @requires_authentication Yes
    # @param status [String] The text of your status update, up to 140 characters.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
    # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::Client::Geo#reverse_geocode}.
    # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The created status.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Update the authenticating user's status
    #   Twitter.update("I'm tweeting with @gem!")
    def update(status, options={})
      status = post("/1/statuses/update.json", options.merge(:status => status))
      Twitter::Status.new(status)
    end

    # Updates with media the authenticating user's status
    #
    # @see http://dev.twitter.com/docs/api/1/post/statuses/update_with_media
    # @note A status update with text/media identical to the authenticating user's current status will NOT be ignored
    # @requires_authentication Yes
    # @rate_limited No
    # @param status [String] The text of your status update, up to 140 characters.
    # @param media [File] A File object with your picture (PNG, JPEG or GIF)
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :in_reply_to_status_id The ID of an existing status that the update is in reply to.
    # @option options [Float] :lat The latitude of the location this tweet refers to. This option will be ignored unless it is inside the range -90.0 to +90.0 (North is positive) inclusive. It will also be ignored if there isn't a corresponding :long option.
    # @option options [Float] :long The longitude of the location this tweet refers to. The valid ranges for longitude is -180.0 to +180.0 (East is positive) inclusive. This option will be ignored if outside that range, if it is not a number, if geo_enabled is disabled, or if there not a corresponding :lat option.
    # @option options [String] :place_id A place in the world. These IDs can be retrieved from {Twitter::Client::Geo#reverse_geocode}.
    # @option options [String] :display_coordinates Whether or not to put a pin on the exact coordinates a tweet has been sent from.
    # @option options [Boolean, String, Integer] :trim_user Each tweet returned in a timeline will include a user object with only the author's numerical ID when set to true, 't' or 1.
    # @return [Twitter::Status] The created status.
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Update the authenticating user's status
    #   Twitter.update_with_media("I'm tweeting with @gem!", File.new('my_awesome_pic.jpeg'))
    #   Twitter.update_with_media("I'm tweeting with @gem!", {'io' => StringIO.new(pic), 'type' => 'jpg'})
    def update_with_media(status, image, options={})
      status = post("/1/statuses/update_with_media.json", options.merge('media[]' => image, 'status' => status), :endpoint => media_endpoint)
      Twitter::Status.new(status)
    end

    # Returns extended information for up to 100 users
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/lookup
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload users(*users, options={})
    #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
    #   @param options [Hash] A customizable set of options.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @return [Array<Twitter::User>] The requested users.
    #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    #   @example Return extended information for @sferik and @pengwynn
    #     Twitter.users('sferik', 'pengwynn')
    #     Twitter.users(7505382, 14100886)    # Same as above
    def users(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      users = args
      options.merge_users!(Array(users))
      get("/1/users/lookup.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

    # Access the profile image in various sizes for the user with the indicated screen name
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/profile_image/:screen_name
    # @rate_limited No
    # @requires_authentication No
    # @overload profile_image(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :size ('normal') Specifies the size of image to fetch. Valid options include: 'bigger' (73px by 73px), 'normal' (48px by 48px), and 'mini' (24px by 24px).
    #   @example Return the URL for the 24px by 24px version of @sferik's profile image
    #     Twitter.profile_image(:size => 'mini')
    # @overload profile_image(screen_name, options={})
    #   @param user [String, Twitter::User] A Twitter screen name or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [String] :size ('normal') Specifies the size of image to fetch. Valid options include: 'bigger' (73px by 73px), 'normal' (48px by 48px), and 'mini' (24px by 24px).
    #   @example Return the URL for the 24px by 24px version of @sferik's profile image
    #     Twitter.profile_image('sferik', :size => 'mini')
    # @return [String] The URL for the requested user's profile image.
    def profile_image(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      user = args.pop || self.current_user.screen_name
      user = user.screen_name if user.is_a?(Twitter::User)
      get("/1/users/profile_image/#{user}", options, :raw => true).headers['location']
    end

    # Returns users that match the given query
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/search
    # @rate_limited Yes
    # @requires_authentication Yes
    # @param query [String] The search query to run against people search.
    # @param options [Hash] A customizable set of options.
    # @option options [Integer] :per_page The number of people to retrieve. Maxiumum of 20 allowed per page.
    # @option options [Integer] :page Specifies the page of results to retrieve.
    # @return [Array<Twitter::User>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    # @example Return users that match "Erik Michaels-Ober"
    #   Twitter.user_search("Erik Michaels-Ober")
    def user_search(query, options={})
      get("/1/users/search.json", options.merge(:q => query)).map do |user|
        Twitter::User.new(user)
      end
    end

    # Returns extended information of a given user
    #
    # @see https://dev.twitter.com/docs/api/1/get/users/show
    # @rate_limited Yes
    # @requires_authentication No
    # @overload user(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @return [Twitter::User] The requested user.
    #   @example Return extended information for @sferik
    #     Twitter.user('sferik')
    #     Twitter.user(7505382)  # Same as above
    def user(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      if user = args.pop
        options.merge_user!(user)
        user = get("/1/users/show.json", options)
      else
        user = get("/1/account/verify_credentials.json", options)
      end
      Twitter::User.new(user)
    end

    # Returns true if the specified user exists
    #
    # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    # @return [Boolean] true if the user exists, otherwise false.
    # @example Return true if @sferik exists
    #     Twitter.user?('sferik')
    #     Twitter.user?(7505382)  # Same as above
    # @requires_authentication No
    # @rate_limited Yes
    def user?(user, options={})
      options.merge_user!(user)
      get("/1/users/show.json", options, :raw => true)
      true
    rescue Twitter::Error::NotFound
      false
    end

    # Returns an array of users that the specified user can contribute to
    #
    # @see http://dev.twitter.com/docs/api/1/get/users/contributees
    # @rate_limited Yes
    # @requires_authentication No unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @overload contributees(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
    #   @return [Array<Twitter::User>]
    #   @example Return the authenticated user's contributees
    #     Twitter.contributees
    # @overload contributees(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
    #   @return [Array<Twitter::User>]
    #   @example Return users @sferik can contribute to
    #     Twitter.contributees('sferik')
    #     Twitter.contributees(7505382)  # Same as above
    def contributees(*args)
      options = {}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop || self.current_user.screen_name
      options.merge_user!(user)
      get("/1/users/contributees.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

    # Returns an array of users who can contribute to the specified account
    #
    # @see http://dev.twitter.com/docs/api/1/get/users/contributors
    # @rate_limited Yes
    # @requires_authentication No unless requesting it from a protected user
    #
    #   If getting this data of a protected user, you must authenticate (and be allowed to see that user).
    # @overload contributors(options={})
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
    #   @return [Array<Twitter::User>]
    #   @example Return the authenticated user's contributors
    #     Twitter.contributors
    # @overload contributors(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's statuses when set to true, 't' or 1.
    #   @return [Array<Twitter::User>]
    #   @example Return users who can contribute to @sferik's account
    #     Twitter.contributors('sferik')
    #     Twitter.contributors(7505382)  # Same as above
    def contributors(*args)
      options = {}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop || self.current_user.screen_name
      options.merge_user!(user)
      get("/1/users/contributors.json", options).map do |user|
        Twitter::User.new(user)
      end
    end

    # Returns recommended users for the authenticated user
    #
    # @note {https://dev.twitter.com/discussions/1120 Undocumented}
    # @rate_limited Yes
    # @requires_authentication Yes
    # @overload recommendations(options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :limit (20) Specifies the number of records to retrieve.
    #   @option options [String] :excluded Comma-separated list of user IDs to exclude.
    #   @example Return recommended users for the authenticated user
    #     Twitter.recommendations
    # @overload recommendations(user, options={})
    #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, or object.
    #   @param options [Hash] A customizable set of options.
    #   @option options [Integer] :limit (20) Specifies the number of records to retrieve.
    #   @option options [String] :excluded Comma-separated list of user IDs to exclude.
    #   @example Return recommended users for the authenticated user
    #     Twitter.recommendations("sferik")
    # @return [Array<Twitter::User>]
    # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
    def recommendations(*args)
      options = {}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop || self.current_user.screen_name
      options.merge_user!(user)
      options[:excluded] = options[:excluded].join(',') if options[:excluded].is_a?(Array)
      get("/1/users/recommendations.json", options).map do |recommendation|
        Twitter::User.new(recommendation['user'])
      end
    end

    # @note Undocumented
    # @rate_limited Yes
    # @requires_authentication Yes
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
      options = {:cursor => -1}
      options.merge!(args.last.is_a?(Hash) ? args.pop : {})
      user = args.pop || self.current_user.screen_name
      options.merge_user!(user)
      cursor = get("/users/following_followers_of.json", options)
      Twitter::Cursor.new(cursor, 'users', Twitter::User)
    end

  end
end
