module Twitter
  class Client
    # Defines methods related to URLs
    module Urls
      # Returns the canonical version of a URL shortened by Twitter
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @response_format `json`
      # @overload resolve(urls, options={})
      #   @param urls [String] A list of shortened URLs.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hashie::Mash] A hash of URLs with the shortened URLs as the key
      # @example Return the canonical version of a URL shortened by Twitter
      #   Twitter.resolve('http://t.co/uw5bn1w', 'http://t.co/dXvMz9i')
      #   Twitter.resolve(['http://t.co/uw5bn1w', 'http://t.co/dXvMz9i']) # Same as above
      def resolve(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        get("1/urls/resolve", options.merge("urls[]" => args), :format => :json, :phoenix => true)
      end
    end
  end
end
