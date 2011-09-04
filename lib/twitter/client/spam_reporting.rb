module Twitter
  class Client
    # Defines methods related to spam reporting
    # @see Twitter::Client::Block
    module SpamReporting
      # The user specified is blocked by the authenticated user and reported as a spammer
      #
      # @see https://dev.twitter.com/docs/api/1/post/report_spam
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @param user [Integer, String] A Twitter user ID or screen name.
      # @param options [Hash] A customizable set of options.
      # @option options [Boolean, String, Integer] :include_entities Include {https://dev.twitter.com/docs/tweet-entities Tweet Entities} when set to true, 't' or 1.
      # @return [Hashie::Mash] The requested user.
      # @example Report @spam for spam
      #   Twitter.report_spam("spam")
      #   Twitter.report_spam(14589771) # Same as above
      def report_spam(user, options={})
        merge_user_into_options!(user, options)
        response = post('1/report_spam', options)
        format.to_s.downcase == 'xml' ? response['user'] : response
      end
    end
  end
end
