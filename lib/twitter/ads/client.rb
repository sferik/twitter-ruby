require 'twitter/base'
require 'twitter/client'
require 'twitter/ads/api'

module Twitter
  module Ads
    class Client < Twitter::Client
      include Twitter::Ads::API

      attr_accessor :bearer_token

      # @return [Boolean]
      def bearer_token?
        !!bearer_token
      end

      # @return [Boolean]
      def credentials?
        super || bearer_token?
      end
    end
  end
end
