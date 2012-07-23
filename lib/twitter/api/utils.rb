require 'twitter/core_ext/array'
require 'twitter/core_ext/enumerable'
require 'twitter/core_ext/hash'
require 'twitter/cursor'
require 'twitter/user'

module Twitter
  module API
    module Utils
    private

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param url [String]
      # @param params [Hash]
      # @param options [Hash]
      # @return [Object]
      def object_from_response(klass, request_method, url, params={}, options={})
        response = send(request_method.to_sym, url, params, options)
        klass.from_response(response)
      end

      # @param method [Symbol]
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param url [String]
      # @param params [Hash]
      # @param options [Hash]
      # @return [Twitter::Cursor]
      def cursor_from_response(method, klass, request_method, url, params={}, options={})
        response = send(request_method.to_sym, url, params, options)
        Twitter::Cursor.from_response(response, method.to_sym, klass)
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param url [String]
      # @param params [Hash]
      # @param options [Hash]
      # @return [Array]
      def collection_from_response(klass, request_method, url, params={}, options={})
        collection_from_array(klass, send(request_method.to_sym, url, params, options)[:body])
      end

      # @param klass [Class]
      # @param array [Array]
      # @return [Array]
      def collection_from_array(klass, array)
        array.map do |element|
          klass.fetch_or_new(element)
        end
      end

      # @param request_method [Symbol]
      # @param url [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def users_from_response(request_method, url, args)
        options = args.extract_options!
        args.flatten.threaded_map do |user|
          object_from_response(Twitter::User, request_method, url, options.merge_user(user))
        end
      end

    end
  end
end
