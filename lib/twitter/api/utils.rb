require 'twitter/api/arguments'
require 'twitter/cursor'
require 'twitter/user'

module Twitter
  module API
    module Utils

      DEFAULT_CURSOR = -1

    private

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def threaded_user_objects_from_response(request_method, path, args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |user|
          object_from_response(Twitter::User, request_method, path, merge_user(arguments.options, user))
        end
      end

      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def user_objects_from_response(request_method, path, args)
        arguments = Twitter::API::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || screen_name) unless arguments.options[:user_id] || arguments.options[:screen_name]
        objects_from_response(Twitter::User, request_method, path, arguments.options)
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def objects_from_response_with_user(klass, request_method, path, args)
        arguments = Twitter::API::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        objects_from_response(klass, request_method, path, arguments.options)
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Array]
      def objects_from_response(klass, request_method, path, options={})
        response = send(request_method.to_sym, path, options)[:body]
        objects_from_array(klass, response)
      end

      # @param klass [Class]
      # @param array [Array]
      # @return [Array]
      def objects_from_array(klass, array)
        array.map do |element|
          klass.fetch_or_new(element)
        end
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def threaded_object_from_response(klass, request_method, path, args)
        arguments = Twitter::API::Arguments.new(args)
        arguments.flatten.threaded_map do |id|
          object_from_response(klass, request_method, path, arguments.options.merge(:id => id))
        end
      end

      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @return [Object]
      def object_from_response(klass, request_method, path, options={})
        response = send(request_method.to_sym, path, options)
        klass.from_response(response)
      end

      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @param method_name [Symbol]
      # @return [Twitter::Cursor]
      def cursor_from_response_with_user(collection_name, klass, request_method, path, args, method_name)
        arguments = Twitter::API::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || screen_name) unless arguments.options[:user_id] || arguments.options[:screen_name]
        cursor_from_response(collection_name, klass, request_method, path, arguments.options, method_name)
      end

      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param method_name [Symbol]
      # @return [Twitter::Cursor]
      def cursor_from_response(collection_name, klass, request_method, path, options, method_name)
        merge_default_cursor!(options)
        response = send(request_method.to_sym, path, options)
        Twitter::Cursor.from_response(response, collection_name.to_sym, klass, self, method_name, options)
      end

      def handle_forbidden_error(klass, error)
        if error.message == klass::MESSAGE
          raise klass.new
        else
          raise error
        end
      end

      def merge_default_cursor!(options)
        options[:cursor] = DEFAULT_CURSOR unless options[:cursor]
      end

      def screen_name
        @screen_name ||= verify_credentials.screen_name
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
      # @return [Hash]
      def merge_user(hash, user, prefix=nil)
        merge_user!(hash.dup, user, prefix)
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @param hash [Hash]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen_name, or object.
      # @return [Hash]
      def merge_user!(hash, user, prefix=nil)
        case user
        when Integer
          hash[[prefix, "user_id"].compact.join("_").to_sym] = user
        when String
          hash[[prefix, "screen_name"].compact.join("_").to_sym] = user
        when Twitter::User
          hash[[prefix, "user_id"].compact.join("_").to_sym] = user.id
        end
        hash
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @param hash [Hash]
      # @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen_names, or objects.
      # @return [Hash]
      def merge_users(hash, users)
        merge_users!(hash.dup, users)
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @param hash [Hash]
      # @param users [Array<Integer, String, Twitter::User>, Set<Integer, String, Twitter::User>] An array of Twitter user IDs, screen_names, or objects.
      # @return [Hash]
      def merge_users!(hash, users)
        user_ids, screen_names = [], []
        users.flatten.each do |user|
          case user
          when Integer
            user_ids << user
          when String
            screen_names << user
          when Twitter::User
            user_ids << user.id
          end
        end
        hash[:user_id] = user_ids.join(',') unless user_ids.empty?
        hash[:screen_name] = screen_names.join(',') unless screen_names.empty?
        hash
      end

    end
  end
end
