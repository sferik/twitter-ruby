module Twitter
  class Client
    module SpamReporting
      def report_spam(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        post('report_spam', options)
      end
    end
  end
end
