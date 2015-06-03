require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class Card < Twitter::Identity
    include Twitter::Creatable
    # @return [String]
    attr_reader :account_id

    # @return [String]
    attr_reader :card_type, :name

    # @return [String]
    attr_reader :preview_url

    # @return [Boolean]
    predicate_attr_reader :deleted
  end
end
