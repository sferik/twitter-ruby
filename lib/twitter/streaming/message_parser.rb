require "twitter/direct_message"
require "twitter/streaming/deleted_tweet"
require "twitter/streaming/event"
require "twitter/streaming/friend_list"
require "twitter/streaming/stall_warning"
require "twitter/tweet"

module Twitter
  module Streaming
    # Parses streaming messages from the Twitter API
    #
    # @api public
    class MessageParser
      # Parses streaming data into appropriate objects
      #
      # @api public
      # @example
      #   MessageParser.parse(data)
      # @param data [Hash] The streaming data to parse.
      # @return [Twitter::Tweet, Twitter::Streaming::Event, Twitter::DirectMessage, Twitter::Streaming::FriendList, Twitter::Streaming::DeletedTweet, Twitter::Streaming::StallWarning, nil]
      def self.parse(data) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        if data.key?(:id)
          Tweet.new(data)
        elsif data.key?(:event)
          Event.new(data)
        elsif data.key?(:direct_message)
          DirectMessage.new(data.fetch(:direct_message))
        elsif data.key?(:friends)
          FriendList.new(data.fetch(:friends))
        elsif data.key?(:delete) && data.fetch(:delete).key?(:status)
          DeletedTweet.new(data.fetch(:delete).fetch(:status))
        elsif data.key?(:warning)
          StallWarning.new(data.fetch(:warning))
        end
      end
    end
  end
end
