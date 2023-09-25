module X
  module Streaming
    class DeletedTweet < X::Identity
      # @return [Integer]
      attr_reader :user_id
    end
  end
end
