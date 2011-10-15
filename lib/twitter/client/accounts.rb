require 'twitter/rate_limit_status'
require 'twitter/settings'
require 'twitter/user'

module Twitter
  class Client
    # Defines methods related to a user's account
    module Accounts

      # Returns the remaining number of API requests available to the requesting user
      #
      # @see https://dev.twitter.com/docs/api/1/get/account/rate_limit_status
      # @rate_limited Yes
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
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

    end
  end
end
