module Twitter
  class Client
    # Defines methods related twitter's supported features and configuration
    module Help
      # Returns the current configuration used by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/configuration
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @return [Hashie::Mash] Twitter's configuration.
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        response = get('1/help/configuration', options)
        format.to_s.downcase == 'xml' ? response['configuration'] : response
      end

      # Returns the list of languages supported by Twitter
      #
      # @see https://dev.twitter.com/docs/api/1/get/help/languages
      # @rate_limited Yes
      # @requires_authentication No
      # @response_format `json`
      # @response_format `xml`
      # @return [Array]
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        response = get('1/help/languages', options)
        format.to_s.downcase == 'xml' ? response['languages']['language'] : response
      end
    end
  end
end
