require "X/language"
require "X/rest/request"
require "X/rest/utils"

module X
  module REST
    module Help
      include X::REST::Utils

      # Returns the list of languages supported by X
      #
      # @see https://dev.X.com/rest/reference/get/help/languages
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Array<X::Language>]
      def languages(options = {})
        perform_get_with_objects("/1.1/help/languages.json", options, X::Language)
      end

      # Returns {https://X.com/privacy X's Privacy Policy}
      #
      # @see https://dev.X.com/rest/reference/get/help/privacy
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String]
      def privacy(options = {})
        perform_get("/1.1/help/privacy.json", options)[:privacy]
      end

      # Returns {https://X.com/tos X's Terms of Service}
      #
      # @see https://dev.X.com/rest/reference/get/help/tos
      # @rate_limited Yes
      # @authentication Requires user context
      # @raise [X::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [String]
      def tos(options = {})
        perform_get("/1.1/help/tos.json", options)[:tos]
      end
    end
  end
end
