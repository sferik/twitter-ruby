require 'twitter/arguments'
require 'twitter/client'
require 'twitter/rest/utils'
require 'twitter/streaming/cursor'
require 'twitter/streaming/info'

module Twitter
  module Streaming
    class Control < Twitter::Client
      include Twitter::REST::Utils

      BASE_URL = 'https://sitestream.twitter.com:443'
      attr_reader :control_uri

      # Initializes a new Control object
      #
      # @param options [Hash] A customizable set of options.
      # @return [Twitter::Streaming::Control]
      def initialize(options = {})
        @control_uri = options[:control_uri]
        super
      end

      # Add additional authenticated users to a Site stream connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#add
      # @note The user_id parameter can be supplied with up to 100 user IDs, separated with commas.
      # @authentication Requires site stream context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean]
      def add_user(*args)
        arguments = Arguments.new(args)
        user_ids = collect_user_ids(arguments)
        perform_post("#{BASE_URL}#{control_uri}/add_user.json", user_id: user_ids.join(','))
        # Successful add requests will be returned an empty 200 OK response so just return true
        true
      end

      # Obtain information about the followings of specific users present on a Site Streams connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#friends
      # @authentication Requires site stream context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Cursor]
      # @overload friend_ids(user, options = {})
      #   Returns an array of numeric IDs for every user the specified user is following
      #
      #   @param user [Integer, String, Twitter::User] A Twitter user ID, screen name, URI, or object.
      #   @param options [Hash] A customizable set of options.
      def friend_ids(*args)
        cursor_from_response_with_streaming_user(:friends, nil, "#{BASE_URL}#{control_uri}/friends/ids.json", args)
      end

      # Obtain information the current state of a Site stream connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#info
      # @see https://dev.twitter.com/streaming/reference/get/c/stream_id/info
      # @authentication Requires site stream context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Streaming::Info]
      def info
        perform_get_with_object("#{BASE_URL}#{control_uri}/info.json", {}, Twitter::Streaming::Info)
      end

      # Remove authenticated users from a Site stream connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#remove
      # @param user_id [Integer] A customizable set of options.
      # @authentication Requires site stream context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean]
      def remove_user(user_id)
        perform_post("#{BASE_URL}#{control_uri}/remove_user.json", user_id: user_id)
        # Successful removal requests will be returned an empty 200 OK response so just return true
        true
      end

    private

      # @param collection_name [Symbol]
      # @param klass [Class]
      # @param path [String]
      # @param args [Array]
      # @return [Twitter::Cursor]
      def cursor_from_response_with_streaming_user(collection_name, klass, path, args) # rubocop:disable ParameterLists
        arguments = Twitter::Arguments.new(args)
        merge_user!(arguments.options, arguments.pop) unless arguments.options[:user_id]
        perform_post_with_streaming_cursor(path, arguments.options, collection_name, klass)
      end

      # @param method [String]
      # @param path [String]
      # @param options [Hash]
      # @collection_name [Symbol]
      # @param klass [Class]
      def perform_post_with_streaming_cursor(path, options, collection_name, klass = nil) # rubocop:disable ParameterLists
        merge_default_cursor!(options)
        request = Twitter::REST::Request.new(self, :post, path, options)
        Twitter::Streaming::Cursor.new(collection_name.to_sym, klass, request, :follow)
      end
    end
  end
end
