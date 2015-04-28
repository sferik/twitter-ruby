require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class FundingInstrument < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :account_id, :currency, :description, :type

    # @return [Integer]
    attr_reader :credit_limit_local_micro, :funded_amount_local_micro

    predicate_attr_reader :cancelled, :deleted

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
