require 'twitter/arguments'
require 'twitter/client'
require 'twitter/rest/utils'
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
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean]
      def add_user(*args)
        arguments = Arguments.new(args)
        user_ids = collect_user_ids(arguments)
        perform_post("#{BASE_URL}#{control_uri}/add_user.json", user_id: user_ids.join(','))
        # Successful add requests will be returned an empty 200 OK response so just return true
        true
      end

      # Obtain information the current state of a Site stream connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#info
      # @see https://dev.twitter.com/streaming/reference/get/c/stream_id/info
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Twitter::Streaming::Info]
      def info
        perform_get_with_object("#{BASE_URL}#{control_uri}/info.json", {}, Twitter::Streaming::Info)
      end

      # Remove authenticated users from a Site stream connection
      #
      # @see https://dev.twitter.com/streaming/sitestreams/controlstreams#remove
      # @param user_id [Integer] A customizable set of options.
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @return [Boolean]
      def remove_user(user_id)
        perform_post("#{BASE_URL}#{control_uri}/remove_user.json", user_id: user_id)
        # Successful removal requests will be returned an empty 200 OK response so just return true
        true
      end
    end
  end
end
