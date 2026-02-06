require "addressable/uri"
require "twitter/arguments"
require "twitter/cursor"
require "twitter/identity"
require "twitter/rest/request"
require "twitter/user"
require "twitter/utils"
require "uri"

module Twitter
  module REST
    # Utility methods for Twitter REST API requests
    module Utils
      include Twitter::Utils

      # The default cursor position for paginated requests
      DEFAULT_CURSOR = -1

    private

      # Take a URI string or Twitter::Identity object and return its ID
      #
      # @api private
      # @param object [Integer, String, URI, Twitter::Identity] An ID, URI, or object
      # @return [Integer]
      def extract_id(object)
        case object
        when Integer
          object
        when String
          Integer(object.split("/").last)
        when URI, Addressable::URI
          Integer(object.path.split("/").last) # steep:ignore NoMethod
        when Identity
          object.id
        end
      end

      # Perform a GET request
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @return [Hash, Array]
      def perform_get(path, options = {})
        perform_request(:get, path, options)
      end

      # Perform a POST request
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @return [Hash, Array]
      def perform_post(path, options = {})
        perform_request(:post, path, options)
      end

      # Perform an HTTP request
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param params [Hash]
      # @return [Hash, Array]
      def perform_request(request_method, path, options = {}, params = nil)
        Request.new(self, request_method, path, options, params).perform
      end

      # Perform a GET request and return an object
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Object]
      def perform_get_with_object(path, options, klass)
        perform_request_with_object(:get, path, options, klass)
      end

      # Perform a POST request and return an object
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Object]
      def perform_post_with_object(path, options, klass)
        perform_request_with_object(:post, path, options, klass)
      end

      # Perform a request and return an object
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @param params [Hash]
      # @return [Object]
      def perform_request_with_object(request_method, path, options, klass, params = nil)
        response = perform_request(request_method, path, options, params)
        klass.new(response) # steep:ignore UnexpectedPositionalArgument
      end

      # Perform a GET request and return objects
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Array]
      def perform_get_with_objects(path, options, klass)
        perform_request_with_objects(:get, path, options, klass)
      end

      # Perform a POST request and return objects
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Array]
      def perform_post_with_objects(path, options, klass)
        perform_request_with_objects(:post, path, options, klass)
      end

      # Perform a request and return objects
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param options [Hash]
      # @param klass [Class]
      # @return [Array]
      def perform_request_with_objects(request_method, path, options, klass)
        perform_request(request_method, path, options).collect do |element|
          klass.new(element) # steep:ignore UnexpectedPositionalArgument
        end
      end

      # Perform a GET request with cursor pagination
      #
      # @api private
      # @param path [String]
      # @param options [Hash]
      # @param collection_name [Symbol]
      # @param klass [Class]
      # @return [Twitter::Cursor]
      def perform_get_with_cursor(path, options, collection_name, klass = nil)
        limit = options.delete(:limit)
        if options[:no_default_cursor]
          options.delete(:no_default_cursor)
        else
          merge_default_cursor!(options)
        end

        request = Request.new(self, :get, path, options)
        Cursor.new(collection_name, klass, request, limit)
      end

      # Perform parallel user requests
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def parallel_users_from_response(request_method, path, args)
        arguments = Arguments.new(args)
        pmap(arguments) do |user|
          perform_request_with_object(request_method, path, merge_user(arguments.options, user), User) # steep:ignore ArgumentTypeMismatch
        end
      end

      # Get users from response
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array<Twitter::User>]
      def users_from_response(request_method, path, args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || user_id) unless arguments.options.key?(:user_id) || arguments.options.key?(:screen_name)
        perform_request_with_objects(request_method, path, arguments.options, User)
      end

      # Get objects from response with user
      #
      # @api private
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def objects_from_response_with_user(klass, request_method, path, args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop)
        perform_request_with_objects(request_method, path, arguments.options, klass)
      end

      # Perform parallel object requests
      #
      # @api private
      # @param klass [Class]
      # @param request_method [Symbol]
      # @param path [String]
      # @param args [Array]
      # @return [Array]
      def parallel_objects_from_response(klass, request_method, path, args)
        arguments = Arguments.new(args)
        pmap(arguments) do |object|
          perform_request_with_object(request_method, path, arguments.options.merge(id: extract_id(object)), klass)
        end
      end

      # Perform multiple requests for IDs
      #
      # @api private
      # @param request_method [Symbol]
      # @param path [String]
      # @param ids [Array]
      # @return [nil]
      def perform_requests(request_method, path, ids)
        ids.each do |id|
          perform_request(request_method, path, id:)
        end
        nil
      end

      # Get cursor from response with user
      #
      # @api private
      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param path [String]
      # @param args [Array]
      # @return [Twitter::Cursor]
      def cursor_from_response_with_user(collection_name, klass, path, args)
        arguments = Arguments.new(args)
        merge_user!(arguments.options, arguments.pop || user_id) unless arguments.options.key?(:user_id) || arguments.options.key?(:screen_name)
        perform_get_with_cursor(path, arguments.options, collection_name, klass)
      end

      # Get the current user's ID
      #
      # @api private
      # @return [Integer]
      def user_id
        @user_id ||= verify_credentials(skip_status: true).id # steep:ignore NoMethod,UnknownInstanceVariable
      end

      # Check if user_id is set
      #
      # @api private
      # @return [Boolean]
      def user_id?
        instance_variable_defined?(:@user_id)
      end

      # Merge default cursor into options
      #
      # @api private
      # @param options [Hash]
      # @return [void]
      def merge_default_cursor!(options)
        options[:cursor] = DEFAULT_CURSOR unless options[:cursor]
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @api private
      # @param hash [Hash]
      # @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object
      # @param prefix [String]
      # @return [Hash]
      def merge_user(hash, user, prefix = nil)
        merge_user!(hash.dup, user, prefix)
      end

      # Take a user and merge it into the hash with the correct key
      #
      # @api private
      # @param hash [Hash]
      # @param user [Integer, String, URI, Twitter::User] A Twitter user ID, screen name, URI, or object
      # @param prefix [String]
      # @return [Hash]
      def merge_user!(hash, user, prefix = nil)
        case user
        when Integer
          set_compound_key("user_id", user, hash, prefix)
        when String
          set_compound_key("screen_name", user, hash, prefix)
        when URI, Addressable::URI
          set_compound_key("screen_name", user.path.split("/").last, hash, prefix) # steep:ignore NoMethod
        when User
          set_compound_key("user_id", user.id, hash, prefix)
        end
      end

      # Set a compound key in a hash
      #
      # @api private
      # @param key [String]
      # @param value [Object]
      # @param hash [Hash]
      # @param prefix [String]
      # @return [Hash]
      def set_compound_key(key, value, hash, prefix = nil)
        compound_key = [prefix, key].compact.join("_").to_sym
        hash[compound_key] = value
        hash
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @api private
      # @param hash [Hash]
      # @param users [Enumerable<Integer, String, Twitter::User>] A collection of Twitter user IDs, screen_names, or objects
      # @return [Hash]
      def merge_users(hash, users)
        copy = hash.dup
        merge_users!(copy, users)
        copy
      end

      # Take a multiple users and merge them into the hash with the correct keys
      #
      # @api private
      # @param hash [Hash]
      # @param users [Enumerable<Integer, String, URI, Twitter::User>] A collection of Twitter user IDs, screen_names, URIs, or objects
      # @return [void]
      def merge_users!(hash, users)
        user_ids, screen_names = collect_users(users.uniq)
        hash[:user_id] = user_ids.join(",") unless user_ids.empty?
        hash[:screen_name] = screen_names.join(",") unless screen_names.empty?
      end

      # Collect users into user_ids and screen_names arrays
      #
      # @api private
      # @param users [Enumerable]
      # @return [Array<Array, Array>]
      def collect_users(users) # rubocop:disable Metrics/MethodLength
        user_ids = [] #: Array[Integer]
        screen_names = [] #: Array[String]
        users.each do |user|
          case user
          when Integer then user_ids << user
          when User    then user_ids << user.id
          when String  then screen_names << user
          when URI, Addressable::URI then screen_names << user.path.split("/").last # steep:ignore NoMethod
          end
        end
        [user_ids, screen_names]
      end
    end
  end
end
