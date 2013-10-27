module Twitter
  module Streaming
    class FriendList

      attr_reader :friend_ids

      def initialize(friend_ids)
        @friend_ids = friend_ids
      end
    end
  end
end