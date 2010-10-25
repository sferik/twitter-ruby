module Twitter
  class Client
    module Notification
      def enable_notifications(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        response = post('notifications/follow', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end

      def disable_notifications(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        response = post('notifications/leave', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end
    end
  end
end
