require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class LineItem < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :account_id, :campaign_id

    # @return [String]
    attr_reader :bid_unit, :currency, :include_sentiment, :objective, :optimization,
      :placement_type, :primary_web_event_tag

    # @return [Integer]
    attr_reader :bid_amount_local_micro, :total_budget_amount_local_micro

    # @return [Boolean]
    predicate_attr_reader :automatically_select_bid, :deleted
  end
end
