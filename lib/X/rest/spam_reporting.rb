require "X/rest/utils"
require "X/user"

module X
  module REST
    module SpamReporting
      include X::REST::Utils

      # The users specified are blocked by the authenticated user and reported as spammers
      #
      # @see https://dev.X.com/rest/reference/post/users/report_spam
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<X::User>] The reported users.
      # @overload report_spam(*users)
      #   @param users [Enumerable<Integer, String, X::User>] A collection of X user IDs, screen names, or objects.
      # @overload report_spam(*users, options)
      #   @param users [Enumerable<Integer, String, X::User>] A collection of X user IDs, screen names, or objects.
      #   @param options [Hash] A customizable set of options.
      def report_spam(*args)
        parallel_users_from_response(:post, "/1.1/users/report_spam.json", args)
      end
    end
  end
end
