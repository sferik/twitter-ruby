require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class Card < Twitter::Identity
      # @return [String]
      attr_reader :account_id

      # @return [String]
      attr_reader :name

      # @return [String]
      attr_reader :preview_url

      # @return [Boolean]
      predicate_attr_reader :deleted
  end
end
