require 'twitter/api/utils'

module Twitter
  module API
    module Application
      include Twitter::API::Utils

      # Returns Rate Limit Data for the current application
      #
      # @see https://dev.twitter.com/docs/api/1.1/get/application/rate_limit_status
      # @rate_limited Yes
      # @authentication User or App Context
      # @raise [Twitter::Error::Unauthorized] Error raised when credentials are not valid.
      # @return [String]
      def rate_limit_status(options={})
        get("/1.1/application/rate_limit_status.json", options)[:body]
      end
    end
  end
end
