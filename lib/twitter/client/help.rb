module Twitter
  class Client
    # Defines methods related twitter's supported features and configuration
    module Help
      # Returns the current configuration used by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/configuration
      # @rate_limited Yes
      # @requires_authentication No
      # @return [Hashie::Mash] Twitter's configuration.
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        get("/1/help/configuration.json", options)
      end

      # Returns the list of languages supported by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/languages
      # @rate_limited Yes
      # @requires_authentication No
      # @return [Array]
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        get("/1/help/languages.json", options)
      end
    end
  end
end
