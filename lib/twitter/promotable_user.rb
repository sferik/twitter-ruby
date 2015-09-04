require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class PromotableUser < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :account_id, :user_id, :promotable_user_type

    # @return [String]
    predicate_attr_reader :deleted
  end
end
