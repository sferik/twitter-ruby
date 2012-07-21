require 'twitter/api/utils'
require 'twitter/configuration'
require 'twitter/language'

module Twitter
  module API
    module Help
      include Twitter::API::Utils

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :configuration => true,
            :languages => true,
          }
        )
      end

      # Returns the current configuration used by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/configuration
      # @rate_limited Yes
      # @authentication_required No
      # @return [Twitter::Configuration] Twitter's configuration.
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        response = get("/1/help/configuration.json", options)
        Twitter::Configuration.from_response(response)
      end

      # Returns the list of languages supported by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/languages
      # @rate_limited Yes
      # @authentication_required No
      # @return [Array<Twitter::Language>]
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        response = get("/1/help/languages.json", options)
        collection_from_array(response[:body], Twitter::Language)
      end

    end
  end
end
