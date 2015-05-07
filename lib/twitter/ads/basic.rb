require 'twitter/arguments'
require 'twitter/error'
require 'twitter/rest/request'
require 'twitter/ads/utils'
require 'twitter/settings'
require 'twitter/utils'

module Twitter
  module Ads
    module Basic
      include Twitter::Ads::Utils
      include Twitter::Utils

      def delete(path, params={})
        perform_request(:delete, path, params)
      end

      # Perform an HTTP GET request
      def get(path, params={})
        perform_request(:get, path, params)
      end

      # Perform an HTTP POST request
      def post(path, params={})
        signature_params = params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
        perform_request(:post, path, params, signature_params)
      end

      # Perform an HTTP PUT request
      def put(path, params={})
        perform_request(:put, path, params)
      end
    end
  end
end
