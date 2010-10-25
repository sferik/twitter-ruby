module Twitter
  class Client
    module Account
      def verify_credentials(options={})
        get('account/verify_credentials', options)
      end

      def rate_limit_status(options={})
        get('account/rate_limit_status', options)
      end

      def end_session(options={})
        post('account/end_session', options)
      end

      def update_delivery_device(device, options={})
        post('account/update_delivery_device', options.merge(:device => device))
      end

      def update_profile_colors(options={})
        post('account/update_profile_colors', options)
      end

      def update_profile_image(file, options={})
        post('account/update_profile_image', options.merge(:image => file))
      end

      def update_profile_background(file, options={})
        perform_post('account/update_profile_background_image', options.merge(:image => file))
      end

      def update_profile(options={})
        post('account/update_profile', options)
      end
    end
  end
end
