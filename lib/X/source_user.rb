require "X/basic_user"

module X
  class SourceUser < X::BasicUser
    predicate_attr_reader :all_replies, :blocking, :can_dm, :followed_by,
                          :marked_spam, :muting, :notifications_enabled,
                          :want_retweets
  end
end
