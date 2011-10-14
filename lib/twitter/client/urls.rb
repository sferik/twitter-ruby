module Twitter
  class Client
    # Defines methods related to URLs
    module Urls
      # Returns the canonical version of a URL shortened by Twitter
      #
      # @note Undocumented
      # @rate_limited Yes
      # @requires_authentication Yes
      # @overload resolve(urls, options={})
      #   @param urls [String] A list of shortened URLs.
      #   @param options [Hash] A customizable set of options.
      #   @return [Hash] A hash of URLs with the shortened URLs as the key
      #   @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      #   @example Return the canonical version of a URL shortened by Twitter
      #     Twitter.resolve('http://t.co/uw5bn1w', 'http://t.co/dXvMz9i')
      #     Twitter.resolve(['http://t.co/uw5bn1w', 'http://t.co/dXvMz9i']) # Same as above
      def resolve(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        get("/1/urls/resolve.json", options.merge("urls[]" => args), :phoenix => true)
      end
    end
  end
end
