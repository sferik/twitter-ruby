module Twitter
  class Client
    module Notification
      def enable_notifications(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        post('notifications/follow', options)
      end

      def disable_notifications(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        post('notifications/leave', options)
      end
    end
  end
end
