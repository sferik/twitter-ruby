module Twitter
  module Streaming
    class TooManyFollowsWarning < Twitter::Base
      attr_reader :code, :message, :user_id
    end
  end
end
