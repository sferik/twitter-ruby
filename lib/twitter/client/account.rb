module Twitter
  class Client
    # Defines methods related to a user's account
    module Account
      # Returns the requesting user if authentication was successful, otherwise raises {Twitter::Unauthorized}
      #
      # @see https://dev.twitter.com/docs/api/1/get/account/verify_credentials
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @raise [Twitter::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example Return the requesting user if authentication was successful
      #   Twitter.verify_credentials
      def verify_credentials(options={})
        response = get('account/verify_credentials', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Returns the remaining number of API requests available to the requesting user
      #
      # @see https://dev.twitter.com/docs/api/1/get/account/rate_limit_status
      # @rate_limited Yes
      # @requires_authentication No
      #
      #   This will return the requesting IP's rate limit status. If you want the authenticating user's rate limit status you must authenticate.
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash]
      # @example Return the remaining number of API requests available to the requesting user
      #   Twitter.rate_limit_status
      def rate_limit_status(options={})
        response = get('account/rate_limit_status', options)
        format.to_s.downcase == 'xml' ? response['hash'] : response
      end

      # Ends the session of the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/end_session
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @return [Hashie::Mash]
      # @example End the session of the authenticating user
      #   Twitter.end_session
      def end_session(options={})
        response = post('account/end_session', options)
        format.to_s.downcase == 'xml' ? response['hash'] : response
      end

      # Sets which device Twitter delivers updates to for the authenticating user
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/update_delivery_device
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param device [String] Must be one of: 'sms', 'none'.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @example Turn SMS updates on for the authenticating user
      #   Twitter.update_delivery_device('sms')
      def update_delivery_device(device, options={})
        response = post('account/update_delivery_device', options.merge(:device => device))
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Sets one or more hex values that control the color scheme of the authenticating user's profile
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_colors
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [String] :profile_background_color Profile background color.
      # @option options [String] :profile_text_color Profile text color.
      # @option options [String] :profile_link_color Profile link color.
      # @option options [String] :profile_sidebar_fill_color Profile sidebar's background color.
      # @option options [String] :profile_sidebar_border_color Profile sidebar's border color.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @example Set authenticating user's profile background to black
      #   Twitter.update_profile_colors(:profile_background_color => '000000')
      def update_profile_colors(options={})
        response = post('account/update_profile_colors', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Updates the authenticating user's profile image
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_image
      # @note This method asynchronously processes the uploaded file before updating the user's profile image URL. You can either update your local cache the next time you request the user's information, or, at least 5 seconds after uploading the image, ask for the updated URL using {Twitter::Client::User#profile_image}.
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param image [String] The avatar image for the profile. Must be a valid GIF, JPG, or PNG image of less than 700 kilobytes in size. Images with width larger than 500 pixels will be scaled down. Animated GIFs will be converted to a static GIF of the first frame, removing the animation.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @example Update the authenticating user's profile image
      #   Twitter.update_profile_image(File.new("me.jpeg"))
      def update_profile_image(image, options={})
        response = post('account/update_profile_image', options.merge(:image => image))
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Updates the authenticating user's profile background image
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/update_profile_background_image
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param image [String] The background image for the profile. Must be a valid GIF, JPG, or PNG image of less than 800 kilobytes in size. Images with width larger than 2048 pixels will be scaled down.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean] :tile Whether or not to tile the background image. If set to true the background image will be displayed tiled. The image will not be tiled otherwise.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @example Update the authenticating user's profile background image
      #   Twitter.update_profile_background_image(File.new("we_concept_bg2.png"))
      def update_profile_background_image(image, options={})
        response = post('account/update_profile_background_image', options.merge(:image => image))
        format.to_s.downcase == 'xml' ? response['user'] : response
      end

      # Sets values that users are able to set under the "Account" tab of their settings page
      #
      # @see https://dev.twitter.com/docs/api/1/post/account/update_profile
      # @note Only the options specified will be updated.
      # @rate_limited No
      # @requires_authentication Yes
      # @response_format `json`
      # @response_format `xml`
      # @param options [Hash] A customizable set of options.
      # @option options [String] :name Full name associated with the profile. Maximum of 20 characters.
      # @option options [String] :url URL associated with the profile. Will be prepended with "http://" if not present. Maximum of 100 characters.
      # @option options [String] :location The city or country describing where the user of the account is located. The contents are not normalized or geocoded in any way. Maximum of 30 characters.
      # @option options [String] :description A description of the user owning the account. Maximum of 160 characters.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The authenticated user.
      # @example Set authenticating user's name to Erik Michaels-Ober
      #   Twitter.update_profile(:name => "Erik Michaels-Ober")
      def update_profile(options={})
        response = post('account/update_profile', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
    end
  end
end
