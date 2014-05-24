require 'addressable/uri'
require 'twitter/arguments'
require 'twitter/request'
require 'twitter/user'
require 'twitter/utils'

module Twitter
  module REST
    module Utils
      include Twitter::Utils
      URI_SUBSTRING = '://'
      DEFAULT_CURSOR = -1

    private

      # Take a URI string or Twitter::Identity object and return its ID
      #
      # @param object [Integer, String, URI, Twitter::Identity] An ID, URI, or object.
      # @return [Integer]
      def extract_id(object)
        case object
        when ::Integer
          object
        when ::String
          object.split('/').last.to_i
        when URI
          object.path.split('/').last.to_i
        when Twitter::Identity
          object.id
        end
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_with_object(request_method, path, options, klass)
        request = Twitter::Request.new(self, request_method, path, options)
        request.perform_with_object(klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_with_objects(request_method, path, options, klass)
        request = Twitter::Request.new(self, request_method, path, options)
        request.perform_with_objects(klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      def perform_with_cursor(request_method, path, options, collection_name, klass = nil) # rubocop:disable ParameterLists
        merge_default_cursor!(options)
        request = Twitter::Request.new(self, request_method, path, options)
        request.perform_with_cursor(collection_name.to_sym, klass)
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def parallel_users_from_response(request_method, path, args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |user|
          perform_with_object(request_method, path, merge_user(arguments.options, user), Twitter::User)
        end
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def users_from_response(request_method, path, args)
        arguments = Twitter::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || user_id) unless arguments.options[:user_id] || arguments.options[:screen_name]
        perform_with_objects(request_method, path, arguments.options, Twitter::User)
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def objects_from_response_with_user(klass, request_method, path, args)
        arguments = Twitter::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        perform_with_objects(request_method, path, arguments.options, klass)
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def parallel_objects_from_response(klass, request_method, path, args)
        arguments = Twitter::Arguments.new(args)
        pmap(arguments) do |object|
          perform_with_object(request_method, path, arguments.options.merge(:id => extract_id(object)), klass)
        end
      end

      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Twitter::Cursor]
      def cursor_from_response_with_user(collection_name, klass, request_method, path, args) # rubocop:disable ParameterLists
        arguments = Twitter::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || user_id) unless arguments.options[:user_id] || arguments.options[:screen_name]
        perform_with_cursor(request_method, path, arguments.options, collection_name, klass)
      end

      def user_id
        @user_id ||= verify_credentials(:skip_status => true).id
      end

      def user_id?
        instance_variable_defined?(:@user_id)
      end

      def merge_default_cursor!(options)
        options[:cursor] = DEFAULT_CURSOR unless options[:cursor]
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @return [Hash]
      def merge_user(hash, user, prefix = nil)
        merge_user!(hash.dup, user, prefix)
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param user [Integer, String, URI, Twitter::User] A Twitter user ID, screen name, URI, or object.
      # @return [Hash]
      def merge_user!(hash, user, prefix = nil)
        case user
        when Integer
          set_compound_key('user_id', user, hash, prefix)
        when String
          if user[URI_SUBSTRING]
            set_compound_key('screen_name', user.split('/').last, hash, prefix)
          else
            set_compound_key('screen_name', user, hash, prefix)
          end
        when URI, Addressable::URI
          set_compound_key('screen_name', user.path.split('/').last, hash, prefix)
        when Twitter::User
          set_compound_key('user_id', user.id, hash, prefix)
        end
      end

      def set_compound_key(key, value, hash, prefix = nil)
        compound_key = [prefix, key].compact.join('_').to_sym
        hash[compound_key] = value
        hash
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @param hash [Hash]
      # @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen_names, or objects.
      # @return [Hash]
      def merge_users(hash, users)
        merge_users!(hash.dup, users)
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @param hash [Hash]
      # @param users [Enumerable<Integer, String, URI, Twitter::User>] A collection of Twitter user IDs, screen_names, URIs, or objects.
      # @return [Hash]
      def merge_users!(hash, users)
        user_ids, screen_names = collect_user_ids_and_screen_names(users)
        hash[:user_id] = user_ids.join(',') unless user_ids.empty?
        hash[:screen_name] = screen_names.join(',') unless screen_names.empty?
        hash
      end

      def collect_user_ids_and_screen_names(users) # rubocop:disable MethodLength
        user_ids, screen_names = [], []
        users.flatten.each do |user|
          case user
          when Integer
            user_ids << user
          when String
            if user[URI_SUBSTRING]
              screen_names << user.split('/').last
            else
              screen_names << user
            end
          when URI
            screen_names << user.path.split('/').last
          when Twitter::User
            user_ids << user.id
          end
        end
        [user_ids, screen_names]
      end
    end
  end
end
