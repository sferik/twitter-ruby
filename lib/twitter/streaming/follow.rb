module Twitter
  module Streaming
    class Follow < Twitter::Base
      attr_reader :user, :other_users
    end
  end
end
