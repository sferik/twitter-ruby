require 'twitter/configuration'
require 'twitter/language'

module Twitter
  class Client
    # Defines methods related twitter's supported features and configuration
    module Help

      # Returns the current configuration used by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/configuration
      # @rate_limited Yes
      # @requires_authentication No
      # @return [Twitter::Configuration] Twitter's configuration.
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        configuration = get("/1/help/configuration.json", options)
        Twitter::Configuration.new(configuration)
      end

      # Returns the list of languages supported by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/languages
      # @rate_limited Yes
      # @requires_authentication No
      # @return [Array<Twitter::Language>]
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        get("/1/help/languages.json", options).map do |language|
          Twitter::Language.new(language)
        end
      end

    end
  end
end
