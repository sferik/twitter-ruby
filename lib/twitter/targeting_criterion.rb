require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class TargetingCriterion < Twitter::Identity
    include Twitter::Creatable

    # @return [String, Integer]
    attr_reader :targeting_value

    # @return [String]
    attr_reader :account_id, :line_item_id, :name, :targeting_type

    predicate_attr_reader :deleted
  end
end
