require "twitter/language"
require "twitter/rest/request"
require "twitter/rest/utils"

module Twitter
  module REST
    # Methods for accessing Twitter help resources
    module Help
      include Twitter::REST::Utils

      # Returns the list of languages supported by Twitter
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/help/languages
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.languages
      # @return [Array<Twitter::Language>]
      def languages(options = {})
        perform_get_with_objects("/1.1/help/languages.json", options, Twitter::Language)
      end

      # Returns Twitter's Privacy Policy
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/help/privacy
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.privacy
      # @return [String]
      def privacy(options = {})
        perform_get("/1.1/help/privacy.json", options)[:privacy]
      end

      # Returns Twitter's Terms of Service
      #
      # @api public
      # @see https://dev.twitter.com/rest/reference/get/help/tos
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @example
      #   client.tos
      # @return [String]
      def tos(options = {})
        perform_get("/1.1/help/tos.json", options)[:tos]
      end
    end
  end
end
