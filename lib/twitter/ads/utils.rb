require 'addressable/uri'
require 'twitter/ads/cursor'
require 'twitter/arguments'
require 'twitter/rest/request'
require 'twitter/utils'
require 'uri'

module Twitter
  module Ads
    module Utils
      DEFAULT_CURSOR = -1

    private

      # @param path [String]
      # @param options [Hash]
      def perform_get(path, options = {})
        perform_request(:get, path, options)
      end

      # @param path [String]
      # @param options [Hash]
      def perform_post(path, options = {})
        perform_request(:post, path, options)
      end

      # Ads endpoints all wrap their responses in a request & data envelope.
      #
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      def perform_request(request_method, path, options = {})
        Twitter::REST::Request.new(self, request_method, path, options).perform
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_get_with_object(path, options, klass)
        perform_request_with_object(:get, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_object(path, options, klass)
        perform_request_with_object(:post, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_put_with_object(path, options, klass)
        perform_request_with_object(:put, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_delete_with_object(path, options, klass)
        perform_request_with_object(:delete, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_object(request_method, path, options, klass)
        response = perform_request(request_method, path, options)
        klass.new(response.fetch(:data, response))
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_get_with_objects(path, options, klass)
        perform_request_with_objects(:get, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_post_with_objects(path, options, klass)
        perform_request_with_objects(:post, path, options, klass)
      end

      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_put_with_objects(path, options, klass)
        perform_request_with_objects(:put, path, options, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_request_with_objects(request_method, path, options, klass)
        request = perform_request(request_method, path, options)
        request.fetch(:data, request).collect do |element|
          klass.new(element)
        end
      end

      # @param path [String]
      # @param options [Hash]
      # @param collection_name [Symbol]
      # @param klass [Class]
      def perform_get_with_cursor(path, options, collection_name, klass = nil)
        request = Twitter::REST::Request.new(self, :get, path, options)
        Twitter::Ads::Cursor.new(collection_name.to_sym, klass, request)
      end
    end
  end
end
