require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class PromotedTweet < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :approval_status, :line_item_id, :tweet_id

    predicate_attr_reader :deleted, :paused
  end
end
