require "X/direct_message"
require "X/streaming/deleted_tweet"
require "X/streaming/event"
require "X/streaming/friend_list"
require "X/streaming/stall_warning"
require "X/tweet"

module X
  module Streaming
    class MessageParser
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
