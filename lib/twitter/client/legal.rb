module Twitter
  class Client
    # Defines methods related to legal documents
    module Legal

      # Returns {https://twitter.com/privacy Twitter's Privacy Policy}
      #
      # @see https://dev.twitter.com/docs/api/1/get/legal/privacy
      # @rate_limited Yes
      # @requires_authentication No
      # @return [String]
      # @example Return {https://twitter.com/privacy Twitter's Privacy Policy}
      #   Twitter.privacy
      def privacy(options={})
        get("/1/legal/privacy.json", options)['privacy']
      end

      # Returns {https://twitter.com/tos Twitter's Terms of Service}
      #
      # @see https://dev.twitter.com/docs/api/1/get/legal/tos
      # @rate_limited Yes
      # @requires_authentication No
      # @return [String]
      # @example Return {https://twitter.com/tos Twitter's Terms of Service}
      #   Twitter.tos
      def tos(options={})
        get("/1/legal/tos.json", options)['tos']
      end

    end
  end
end
