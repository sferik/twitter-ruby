module Twitter
  class Client
    module SpamReporting
      def report_spam(user, options={})
        authenticate!
        merge_user_into_options!(user, options)
        response = post('report_spam', options)
        format.to_s.downcase == 'xml' ? response.user : response
      end
    end
  end
end
