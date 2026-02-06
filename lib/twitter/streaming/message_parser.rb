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
        if data[:id]
          Tweet.new(data)
        elsif data[:event]
          Event.new(data)
        elsif data[:direct_message]
          DirectMessage.new(data[:direct_message])
        elsif data[:friends]
          FriendList.new(data[:friends])
        elsif data[:delete] && data[:delete][:status]
          DeletedTweet.new(data[:delete][:status])
        elsif data[:warning]
          StallWarning.new(data[:warning])
        end
      end
    end
  end
end
