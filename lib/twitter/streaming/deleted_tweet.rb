module Twitter
  module Streaming
    # Represents a deleted tweet from the streaming API
    #
    # @api public
    class DeletedTweet < Twitter::Identity
      # Returns the user ID of the deleted tweet's author
      #
      # @api public
      # @example
      #   deleted_tweet.user_id
      # @return [Integer]
      attr_reader :user_id
    end
  end
end
