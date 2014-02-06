require 'twitter/basic_user'

module Twitter
  class SourceUser < Twitter::BasicUser
    attr_reader :all_replies, :blocking, :can_dm, :followed_by, :marked_spam,
                :notifications_enabled, :want_retweets

    def attributes
        @attrs
    end

    def attr
        @attrs
    end
    
  end
end
