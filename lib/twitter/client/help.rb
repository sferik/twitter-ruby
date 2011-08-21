module Twitter
  class Client
    # Defines methods related twitter's supported features and configuration
    module Help
      # Returns the current configuration used by Twitter
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @return [Hashie::Mash] Twitter's configuration.
      # @see http://dev.twitter.com/doc/get/help/configuration
      # @example Return the current configuration used by Twitter
      #   Twitter.configuration
      def configuration(options={})
        response = get('help/configuration', options)
        format.to_s.downcase == 'xml' ? response['configuration'] : response
      end

      # Returns the list of languages supported by Twitter
      #
      # @format :json, :xml
      # @authenticated false
      # @rate_limited true
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/help/languages
      # @example Return the list of languages Twitter supports
      #   Twitter.languages
      def languages(options={})
        response = get('help/languages', options)
        format.to_s.downcase == 'xml' ? response['languages']['language'] : response
      end
    end
  end
end
