module Twitter
  module Streaming
    class DeletedTweet < Twitter::Identity
      attr_reader :user_id
    end
    DeletedStatus = DeletedTweet # rubocop:disable ConstantName
  end
end
