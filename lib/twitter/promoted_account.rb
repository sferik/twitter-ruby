require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class PromotedAccount < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :approval_status, :line_item_id, :user_id

    predicate_attr_reader :deleted, :paused
  end
end
