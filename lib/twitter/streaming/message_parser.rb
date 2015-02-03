require 'twitter/direct_message'
require 'twitter/streaming/control'
require 'twitter/streaming/deleted_tweet'
require 'twitter/streaming/disconnect'
require 'twitter/streaming/envelope'
require 'twitter/streaming/event'
require 'twitter/streaming/friend_list'
require 'twitter/streaming/limit'
require 'twitter/streaming/scrub_geo'
require 'twitter/streaming/stall_warning'
require 'twitter/streaming/status_withheld'
require 'twitter/streaming/too_many_follows_warning'
require 'twitter/streaming/user_withheld'
require 'twitter/tweet'

module Twitter
  module Streaming
    class MessageParser
      FALLING_BEHIND = 'FALLING_BEHIND'
      FOLLOWS_OVER_LIMIT = 'FOLLOWS_OVER_LIMIT'

      def self.parse(data, client = nil) # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
        if data[:recipient] && data[:sender]
          DirectMessage.new(data)
        elsif data[:id]
          Tweet.new(data)
        elsif data[:control]
          Control.new(client.credentials.merge(data[:control]))
        elsif data[:event]
          Event.new(data)
        elsif data[:for_user]
          Envelope.new(data)
        elsif data[:delete] && data[:delete][:status]
          DeletedTweet.new(data[:delete][:status])
        elsif data[:disconnect]
          Disconnect.new(data[:disconnect])
        elsif data[:friends]
          FriendList.new(data[:friends])
        elsif data[:limit]
          Limit.new(data[:limit])
        elsif data[:scrub_geo]
          ScrubGeo.new(data[:scrub_geo])
        elsif data[:status_withheld]
          StatusWithheld.new(data[:status_withheld])
        elsif data[:user_withheld]
          UserWithheld.new(data[:user_withheld])
        elsif data[:warning] && data[:warning][:code] == FALLING_BEHIND
          StallWarning.new(data[:warning])
        elsif data[:warning] && data[:warning][:code] == FOLLOWS_OVER_LIMIT
          TooManyFollowsWarning.new(data[:warning])
        end
      end

      attr_reader :client

      def initialize(client)
        @client = client
      end

      def parse(data)
        MessageParser.parse(data, client)
      end
    end
  end
end
