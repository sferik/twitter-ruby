module Twitter
  class Client
    module Account
      def verify_credentials(options={})
        response = get('account/verify_credentials', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def rate_limit_status(options={})
        response = get('account/rate_limit_status', options)
        format.to_s.downcase == 'xml' ? response['hash'] : response
      end

      def end_session(options={})
        response = post('account/end_session', options)
        format.to_s.downcase == 'xml' ? response['hash'] : response
      end

      def update_delivery_device(device, options={})
        response = post('account/update_delivery_device', options.merge(:device => device))
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def update_profile_colors(options={})
        response = post('account/update_profile_colors', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def update_profile_image(file, options={})
        response = post('account/update_profile_image', options.merge(:image => file))
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def update_profile_background_image(file, options={})
        response = post('account/update_profile_background_image', options.merge(:image => file))
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def update_profile(options={})
        response = post('account/update_profile', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end
    end
  end
end
