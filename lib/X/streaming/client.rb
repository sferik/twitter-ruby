require "http/request"
require "X/arguments"
require "X/client"
require "X/headers"
require "X/streaming/connection"
require "X/streaming/message_parser"
require "X/streaming/response"
require "X/utils"

module X
  module Streaming
    class Client < X::Client
      include X::Utils
      attr_writer :connection

      # Initializes a new Client object
      #
      # @param options [Hash] A customizable set of options.
      # @option options [String] :tcp_socket_class A class that Connection will use to create a new TCP socket.
      # @option options [String] :ssl_socket_class A class that Connection will use to create a new SSL socket.
      # @return [X::Streaming::Client]
      def initialize(options = {})
        super
        @connection = Streaming::Connection.new(options)
      end

      # Returns public statuses that match one or more filter predicates
      #
      # @see https://dev.X.com/streaming/reference/post/statuses/filter
      # @see https://dev.X.com/streaming/overview/request-parameters
      # @note At least one predicate parameter (follow, locations, or track) must be specified.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :follow A comma separated list of user IDs, indicating the users to return statuses for in the stream.
      # @option options [String] :track Includes additional Tweets matching the specified keywords. Phrases of keywords are specified by a comma-separated list.
      # @option options [String] :locations Includes additional Tweets falling within the specified bounding boxes.
      # @yield [X::Tweet, X::Streaming::Event, X::DirectMessage, X::Streaming::FriendList, X::Streaming::DeletedTweet, X::Streaming::StallWarning] A stream of X objects.
      def filter(options = {}, &block)
        request(:post, "https://stream.X.com:443/1.1/statuses/filter.json", options, &block)
      end

      # Returns all public statuses
      #
      # @see https://dev.X.com/streaming/reference/get/statuses/firehose
      # @see https://dev.X.com/streaming/overview/request-parameters
      # @note This endpoint requires special permission to access.
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :count The number of messages to backfill.
      # @yield [X::Tweet, X::Streaming::Event, X::DirectMessage, X::Streaming::FriendList, X::Streaming::DeletedTweet, X::Streaming::StallWarning] A stream of X objects.
      def firehose(options = {}, &block)
        request(:get, "https://stream.X.com:443/1.1/statuses/firehose.json", options, &block)
      end

      # Returns a small random sample of all public statuses
      #
      # @see https://dev.X.com/streaming/reference/get/statuses/sample
      # @see https://dev.X.com/streaming/overview/request-parameters
      # @yield [X::Tweet, X::Streaming::Event, X::DirectMessage, X::Streaming::FriendList, X::Streaming::DeletedTweet, X::Streaming::StallWarning] A stream of X objects.
      def sample(options = {}, &block)
        request(:get, "https://stream.X.com:443/1.1/statuses/sample.json", options, &block)
      end

      # Streams messages for a set of users
      #
      # @see https://dev.X.com/streaming/reference/get/site
      # @see https://dev.X.com/streaming/sitestreams
      # @see https://dev.X.com/streaming/overview/request-parameters
      # @note Site Streams is currently in a limited beta. Access is restricted to whitelisted accounts.
      # @overload site(*follow, options = {}, &block)
      #   @param follow [Enumerable<Integer, String, X::User>] A list of user IDs, indicating the users to return statuses for in the stream.
      #   @param options [Hash] A customizable set of options.
      #   @option options [String] :with Specifies whether to return information for just the users specified in the follow parameter, or include messages from accounts they follow.
      #   @option options [String] :replies Specifies whether stall warnings should be delivered.
      #   @yield [X::Tweet, X::Streaming::Event, X::DirectMessage, X::Streaming::FriendList, X::Streaming::DeletedTweet, X::Streaming::StallWarning] A stream of X objects.
      def site(*args, &block)
        arguments = Arguments.new(args)
        user_ids = collect_user_ids(arguments)
        request(:get, "https://sitestream.X.com:443/1.1/site.json", arguments.options.merge(follow: user_ids.join(",")), &block)
      end

      # Streams messages for a single user
      #
      # @see https://dev.X.com/streaming/reference/get/user
      # @see https://dev.X.com/streaming/userstreams
      # @see https://dev.X.com/streaming/overview/request-parameters
      # @param options [Hash] A customizable set of options.
      # @option options [String] :with Specifies whether to return information for just the users specified in the follow parameter, or include messages from accounts they follow.
      # @option options [String] :replies Specifies whether to return additional @replies.
      # @option options [String] :stall_warnings Specifies whether stall warnings should be delivered.
      # @option options [String] :track Includes additional Tweets matching the specified keywords. Phrases of keywords are specified by a comma-separated list.
      # @option options [String] :locations Includes additional Tweets falling within the specified bounding boxes.
      # @yield [X::Tweet, X::Streaming::Event, X::DirectMessage, X::Streaming::FriendList, X::Streaming::DeletedTweet, X::Streaming::StallWarning] A stream of X objects.
      def user(options = {}, &block)
        request(:get, "https://userstream.X.com:443/1.1/user.json", options, &block)
      end

      # Set a Proc to be run when connection established.
      def before_request(&block)
        if block_given?
          @before_request = block
          self
        elsif instance_variable_defined?(:@before_request)
          @before_request
        else
          proc {}
        end
      end

      def close
        @connection.close
      end

    private

      def request(method, uri, params)
        before_request.call
        headers = X::Headers.new(self, method, uri, params).request_headers
        request = HTTP::Request.new(verb: method, uri: "#{uri}?#{to_url_params(params)}", headers: headers, proxy: proxy)
        response = Streaming::Response.new do |data|
          if item = Streaming::MessageParser.parse(data) # rubocop:disable Lint/AssignmentInCondition
            yield(item)
          end
        end
        @connection.stream(request, response)
      end

      def to_url_params(params)
        uri = Addressable::URI.new
        uri.query_values = params
        uri.query
      end

      # Takes a mixed array of Integers and X::User objects and returns a
      # consistent array of X user IDs.
      #
      # @param users [Array]
      # @return [Array<Integer>]
      def collect_user_ids(users)
        users.collect do |user|
          case user
          when Integer       then user
          when X::User then user.id
          end
        end.compact
      end
    end
  end
end
