require 'twitter/api/utils'

module Twitter
  module API
    module ReportSpam
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :report_spam => true,
          }
        )
      end

      # The users specified are blocked by the authenticated user and reported as spammers
      #
      # @see https://dev.twitter.com/docs/api/1/post/report_spam
      # @rate_limited Yes
      # @authentication_required No
      # @return [Array<Twitter::User>] The reported users.
      # @overload report_spam(*users)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @example Report @spam for spam
      #     Twitter.report_spam("spam")
      #     Twitter.report_spam(14589771) # Same as above
      # @overload report_spam(*users, options)
      #   @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def report_spam(*args)
        users_from_response(args) do |options|
          post("/1/report_spam.json", options)
        end
      end

    end
  end
end
