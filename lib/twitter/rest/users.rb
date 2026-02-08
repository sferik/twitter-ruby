require "twitter/arguments"
require "twitter/error"
require "twitter/profile_banner"
require "twitter/rest/request"
require "twitter/rest/utils"
require "twitter/settings"
require "twitter/user"
require "twitter/utils"

module Twitter
  module REST
    # Methods for working with Twitter users
    module Users
      include Twitter::REST::Utils
      include Twitter::Utils

      # Maximum users per request
      MAX_USERS_PER_REQUEST = 100

      # Updates or returns the authenticating user's settings
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/settings
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.settings
      # @return [Twitter::Settings]
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :trend_location_woeid The Yahoo! Where On Earth ID.
      # @option options [Boolean, String, Integer] :sleep_time_enabled Enable sleep time.
      # @option options [Integer] :start_sleep_time The hour sleep time should begin.
      # @option options [Integer] :end_sleep_time The hour sleep time should end.
      # @option options [String] :time_zone The timezone for the user.
      # @option options [String] :lang The language which Twitter should render in.
      # @option options [String] :allow_contributor_request Allow others to include user.
      # @option options [String] :current_password The user's password.
      def settings(options = {})
        request_method = options.empty? ? :get : :post
        response = perform_request(request_method, "/1.1/account/settings.json", options)
        # https://dev.twitter.com/issues/59
        empty_array = [] # : Array[untyped]
        response[:trend_location] = response.fetch(:trend_location, empty_array).first
        Settings.new(response)
      end

      # Returns the requesting user if authentication was successful
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/account/verify_credentials
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.verify_credentials
      # @return [Twitter::User] The authenticated user.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets.
      def verify_credentials(options = {})
        perform_get_with_object("/1.1/account/verify_credentials.json", options, User)
      end

      # Sets which device Twitter delivers updates to for the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/update_delivery_device
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.update_delivery_device('sms')
      # @return [Twitter::User] The authenticated user.
      # @param device [String] Must be one of: 'sms', 'none'.
      # @param options [Hash] A customizable set of options.
      def update_delivery_device(device, options = {})
        perform_post_with_object("/1.1/account/update_delivery_device.json", options.merge(device:), User)
      end

      # Sets values that users can set in their profile settings
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/update_profile
      # @note Only the options specified will be updated.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.update_profile(name: 'Erik Michaels-Ober')
      # @return [Twitter::User] The authenticated user.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :name Full name associated with the profile.
      # @option options [String] :url URL associated with the profile.
      # @option options [String] :location The city or country describing the user's location.
      # @option options [String] :description A description of the user.
      # @option options [String] :profile_link_color A hex value for link color.
      def update_profile(options = {})
        perform_post_with_object("/1.1/account/update_profile.json", options, User)
      end

      # Updates the authenticating user's profile background image
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/update_profile_background_image
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.update_profile_background_image(File.new('/path/to/image.png'))
      # @return [Twitter::User] The authenticated user.
      # @param image [File] The background image for the profile.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :tile Whether or not to tile the background image.
      def update_profile_background_image(image, options = {})
        post_profile_image("/1.1/account/update_profile_background_image.json", image, options)
      end

      # Updates the authenticating user's profile image
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/update_profile_image
      # @note This method expects raw multipart data, not a URL to an image.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.update_profile_image(File.new('/path/to/avatar.png'))
      # @return [Twitter::User] The authenticated user.
      # @param image [File] The avatar image for the profile.
      # @param options [Hash] A customizable set of options.
      def update_profile_image(image, options = {})
        post_profile_image("/1.1/account/update_profile_image.json", image, options)
      end

      # Returns users that the authenticating user is blocking
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/blocks/list
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.blocked
      # @return [Array<Twitter::User>] User objects that the authenticating user is blocking.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets.
      def blocked(options = {})
        perform_get_with_cursor("/1.1/blocks/list.json", options, :users, User)
      end

      # Returns user IDs the authenticating user is blocking
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/blocks/ids
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.blocked_ids
      # @return [Twitter::Cursor] Numeric user IDs the authenticating user is blocking.
      # @overload blocked_ids(options = {})
      #   @param options [Hash] A customizable set of options.
      def blocked_ids(*args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        perform_get_with_cursor("/1.1/blocks/ids.json", arguments.options, :ids)
      end

      # Returns true if the authenticating user is blocking a target user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/blocks/ids
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.block?('sferik')
      # @return [Boolean] true if the authenticating user is blocking the target user.
      # @param user [Integer, String, URI, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @param options [Hash] A customizable set of options.
      def block?(user, options = {})
        user_id =
          case user
          when Integer then user
          when String, URI, Addressable::URI then user(user).id
          when User then user.id
          end
        blocked_ids(options).collect(&:to_i).include?(user_id)
      end

      # Blocks the users specified by the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/blocks/create
      # @note Destroys a friendship to the blocked user if it exists.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.block('sferik')
      # @return [Array<Twitter::User>] The blocked users.
      # @overload block(*users)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      # @overload block(*users, options)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def block(*args)
        parallel_users_from_response(:post, "/1.1/blocks/create.json", args)
      end

      # Un-blocks the users specified by the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/blocks/destroy
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.unblock('sferik')
      # @return [Array<Twitter::User>] The un-blocked users.
      # @overload unblock(*users)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      # @overload unblock(*users, options)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def unblock(*args)
        parallel_users_from_response(:post, "/1.1/blocks/destroy.json", args)
      end

      # Returns extended information for up to 100 users
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/lookup
      # @rate_limited Yes
      # @authentication Required
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.users('sferik', 'pengwynn')
      # @return [Array<Twitter::User>] The requested users.
      # @overload users(*users)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      # @overload users(*users, options)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def users(*args)
        arguments = Arguments.new(args)
        flat_pmap(arguments.each_slice(MAX_USERS_PER_REQUEST)) do |users|
          perform_get_with_objects("/1.1/users/lookup.json", merge_users(arguments.options, users), User)
        end
      end

      # Returns extended information for a given user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/show
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.user('sferik')
      # @return [Twitter::User] The requested user.
      # @overload user(options = {})
      #   Returns extended information for the authenticated user
      #
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets when set to true, 't' or 1.
      # @overload user(user, options = {})
      #   Returns extended information for a given user
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets when set to true, 't' or 1.
      def user(*args)
        arguments = Arguments.new(args)
        if arguments.last || user_id?
          merge_user!(arguments.options, arguments.pop || user_id)
          perform_get_with_object("/1.1/users/show.json", arguments.options, User)
        else
          verify_credentials(arguments.options)
        end
      end

      # Returns true if the specified user exists
      #
      # @api public
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.user?('sferik')
      # @return [Boolean] true if the user exists, otherwise false.
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      def user?(user, options = {})
        options = options.dup
        merge_user!(options, user)
        perform_get("/1.1/users/show.json", options)
        true
      rescue Twitter::Error::NotFound
        false
      end

      # Returns users that match the given query
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/search
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.user_search('Erik Michaels-Ober')
      # @return [Array<Twitter::User>]
      # @param query [String] The search query to run against people search.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of people to retrieve.
      # @option options [Integer] :page Specifies the page of results to retrieve.
      def user_search(query, options = {})
        perform_get_with_objects("/1.1/users/search.json", options.merge(q: query), User)
      end

      # Returns users that the specified user can contribute to
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/contributees
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.contributees
      # @return [Array<Twitter::User>]
      # @overload contributees(options = {})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
      # @overload contributees(user, options = {})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
      def contributees(*args)
        users_from_response(:get, "/1.1/users/contributees.json", args)
      end

      # Returns users who can contribute to the specified account
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/contributors
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.contributors
      # @return [Array<Twitter::User>]
      # @overload contributors(options = {})
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
      # @overload contributors(user, options = {})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      #   @option options [Boolean, String, Integer] :skip_status Do not include contributee's Tweets when set to true, 't' or 1.
      def contributors(*args)
        users_from_response(:get, "/1.1/users/contributors.json", args)
      end

      # Removes the authenticating user's profile banner image
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/remove_profile_banner
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.remove_profile_banner
      # @return [nil]
      # @param options [Hash] A customizable set of options.
      # rubocop:disable Naming/PredicateMethod
      def remove_profile_banner(options = {})
        perform_post("/1.1/account/remove_profile_banner.json", options)
        true
      end

      # Updates the authenticating user's profile banner image
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/account/update_profile_banner
      # @note For best results, upload an image that is exactly 1252px by 626px.
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::BadRequest] Error raised when image was not provided.
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @raise [Twitter::Error::UnprocessableEntity] Error raised when image is too large.
      # @example
      #   client.update_profile_banner(File.new('/path/to/banner.png'))
      # @return [nil]
      # @param banner [File] The image data being uploaded as the profile banner.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :width The width of the preferred section.
      # @option options [Integer] :height The height of the preferred section.
      # @option options [Integer] :offset_left The offset from the left.
      # @option options [Integer] :offset_top The offset from the top.
      def update_profile_banner(banner, options = {})
        perform_post("/1.1/account/update_profile_banner.json", options.merge(banner:))
        true
      end
      # rubocop:enable Naming/PredicateMethod

      # Returns the profile banner size variations for a user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/users/profile_banner
      # @note If the user has not uploaded a profile banner, a HTTP 404 is served.
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.profile_banner('sferik')
      # @return [Twitter::ProfileBanner]
      # @overload profile_banner(options = {})
      # @overload profile_banner(user, options = {})
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      def profile_banner(*args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || user_id) unless arguments.options.key?(:user_id) || arguments.options.key?(:screen_name)
        perform_get_with_object("/1.1/users/profile_banner.json", arguments.options, ProfileBanner)
      end

      # Mutes the users specified by the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/mutes/users/create
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.mute('sferik')
      # @return [Array<Twitter::User>] The muted users.
      # @overload mute(*users)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      # @overload mute(*users, options)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def mute(*args)
        parallel_users_from_response(:post, "/1.1/mutes/users/create.json", args)
      end

      # Un-mutes the user specified by the authenticating user
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/post/mutes/users/destroy
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.unmute('sferik')
      # @return [Array<Twitter::User>] The un-muted users.
      # @overload unmute(*users)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      # @overload unmute(*users, options)
      #   @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def unmute(*args)
        parallel_users_from_response(:post, "/1.1/mutes/users/destroy.json", args)
      end

      # Returns users that the authenticating user is muting
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/mutes/users/list
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.muted
      # @return [Array<Twitter::User>] User objects that the authenticating user is muting.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :skip_status Do not include user's Tweets.
      def muted(options = {})
        perform_get_with_cursor("/1.1/mutes/users/list.json", options, :users, User)
      end

      # Returns user IDs the authenticating user is muting
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/mutes/users/ids
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.muted_ids
      # @return [Twitter::Cursor] Numeric user IDs the authenticating user is muting
      # @overload muted_ids(options = {})
      #   @param options [Hash] A customizable set of options.
      def muted_ids(*args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        perform_get_with_cursor("/1.1/mutes/users/ids.json", arguments.options, :ids)
      end

      private

      # Posts a profile image update
      #
      # @api private
      # @return [Twitter::User]
      def post_profile_image(path, image, options)
        response = Request.new(self, :multipart_post, path, options.merge(key: :image, file: image)).perform
        User.new(response)
      end
    end
  end
end
