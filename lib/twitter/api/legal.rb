module Twitter
  module API
    module Legal

      def self.included(klass)
        klass.send(:class_variable_get, :@@rate_limited).merge!(
          {
            :privacy => true,
            :tos => true,
          }
        )
      end

      # Returns {https://twitter.com/privacy Twitter's Privacy Policy}
      #
      # @see https://dev.twitter.com/docs/api/1/get/legal/privacy
      # @rate_limited Yes
      # @authentication_required No
      # @return [String]
      # @example Return {https://twitter.com/privacy Twitter's Privacy Policy}
      #   Twitter.privacy
      def privacy(options={})
        get("/1/legal/privacy.json", options)[:body][:privacy]
      end

      # Returns {https://twitter.com/tos Twitter's Terms of Service}
      #
      # @see https://dev.twitter.com/docs/api/1/get/legal/tos
      # @rate_limited Yes
      # @authentication_required No
      # @return [String]
      # @example Return {https://twitter.com/tos Twitter's Terms of Service}
      #   Twitter.tos
      def tos(options={})
        get("/1/legal/tos.json", options)[:body][:tos]
      end

    end
  end
end
