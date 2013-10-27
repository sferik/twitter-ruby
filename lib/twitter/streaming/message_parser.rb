module Twitter
  module Streaming
    class MessageParser

      def self.parse(data)
        if data[:id]
          Tweet.new(data)
        elsif data[:event]
          Event.new(data)
        elsif data[:direct_message]
          DirectMessage.new(data[:direct_message])
        elsif data[:friends]
          FriendList.new(data[:friends])
        end
      end
    end
  end
end