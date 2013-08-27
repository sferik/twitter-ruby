require 'twitter/arguments'
require 'twitter/cursor'
require 'twitter/user'
require 'uri'

module Twitter
  module REST
    module API
      module Utils

        DEFAULT_CURSOR = -1
        URI_SUBSTRING = "://"

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
            object.split("/").last.to_i
          when ::URI
            object.path.split("/").last.to_i
          when Twitter::Identity
            object.id
          end
        end

        # @param request_method [Symbol]
        # @param path [String]
        # @param args [Array]
        # @return [Array<Twitter::User>]
        def threaded_user_objects_from_response(request_method, path, args)
          arguments = Twitter::Arguments.new(args)
          arguments.flatten.threaded_map do |user|
            object_from_response(Twitter::User, request_method, path, merge_user(arguments.options, user))
          end
        end

        # @param request_method [Symbol]
        # @param path [String]
        # @param args [Array]
        # @return [Array<Twitter::User>]
        def user_objects_from_response(request_method, path, args)
          arguments = Twitter::Arguments.new(args)
          merge_user!(arguments.options, arguments.pop || screen_name) unless arguments.options[:user_id] || arguments.options[:screen_name]
          objects_from_response(Twitter::User, request_method, path, arguments.options)
        end

        # @param klass [Class]
        # @param request_method [Symbol]
        # @param path [String]
        # @param args [Array]
        # @return [Array]
        def objects_from_response_with_user(klass, request_method, path, args)
          arguments = Twitter::Arguments.new(args)
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
            klass.new(element)
          end
        end

        # @param klass [Class]
        # @param request_method [Symbol]
        # @param path [String]
        # @param args [Array]
        # @return [Array]
        def threaded_objects_from_response(klass, request_method, path, args)
          arguments = Twitter::Arguments.new(args)
          arguments.flatten.threaded_map do |object|
            id = extract_id(object)
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
        # @return [Twitter::Cursor]
        def cursor_from_response_with_user(collection_name, klass, request_method, path, args)
          arguments = Twitter::Arguments.new(args)
          merge_user!(arguments.options, arguments.pop || screen_name) unless arguments.options[:user_id] || arguments.options[:screen_name]
          cursor_from_response(collection_name, klass, request_method, path, arguments.options)
        end

        # @param collection_name [Symbol]
        # @param klass [Class]
        # @param request_method [Symbol]
        # @param path [String]
        # @param options [Hash]
        # @return [Twitter::Cursor]
        def cursor_from_response(collection_name, klass, request_method, path, options)
          merge_default_cursor!(options)
          response = send(request_method.to_sym, path, options)
          Twitter::Cursor.from_response(response, collection_name.to_sym, klass, self, request_method, path, options)
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
        # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
        # @return [Hash]
        def merge_user(hash, user, prefix=nil)
          merge_user!(hash.dup, user, prefix)
        end

        # Take a user and merge it into the hash with the correct key
        #
        # @param hash [Hash]
        # @param user [Integer, String, URI, Twitter::User] A Twitter user ID, screen name, URI, or object.
        # @return [Hash]
        def merge_user!(hash, user, prefix=nil)
          case user
          when Integer
            hash[[prefix, "user_id"].compact.join("_").to_sym] = user
          when String
            if user[URI_SUBSTRING]
              hash[[prefix, "screen_name"].compact.join("_").to_sym] = user.split("/").last
            else
              hash[[prefix, "screen_name"].compact.join("_").to_sym] = user
            end
          when ::URI
            hash[[prefix, "screen_name"].compact.join("_").to_sym] = user.path.split("/").last
          when Twitter::User
            hash[[prefix, "user_id"].compact.join("_").to_sym] = user.id
          end
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
          user_ids, screen_names = [], []
          users.flatten.each do |user|
            case user
            when Integer
              user_ids << user
            when String
              if user[URI_SUBSTRING]
                screen_names << user.split("/").last
              else
                screen_names << user
              end
            when ::URI
              screen_names << user.path.split("/").last
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
end
