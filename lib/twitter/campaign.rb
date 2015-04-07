require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class Campaign < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :currency, :name

    # Other record ids
    #
    # @return [String]
    attr_reader :account_id, :funding_instrument_id

    # @return [Array<String>]
    attr_reader :reasons_not_servable

    # @return [Integer]
    attr_reader :total_budget_amount_local_micro, :daily_budget_amount_local_micro

    predicate_attr_reader :deleted, :paused, :servable, :standard_delivery

    # Time when campaign started
    #
    # @return [Time]
    def start_time
      Time.parse(@attrs[:start_time]).utc unless @attrs[:start_time].nil?
    end

    # Time when campaign ended.
    #
    # @return [Time]
    def end_time
      Time.parse(@attrs[:end_time]).utc unless @attrs[:end_time].nil?
    end
  end
end
