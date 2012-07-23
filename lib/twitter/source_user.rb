require 'twitter/basic_user'

module Twitter
  class SourceUser < Twitter::BasicUser
    attr_reader :all_replies, :blocking, :can_dm, :followed_by, :marked_spam,
      :notifications_enabled, :want_retweets
    alias all_replies? all_replies
    alias blocking? blocking
    alias can_dm? can_dm
    alias followed_by? followed_by
    alias marked_spam? marked_spam
    alias notifications_enabled? notifications_enabled
    alias want_retweets? want_retweets
  end
end
