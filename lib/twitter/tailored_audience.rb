require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class TailoredAudience < Twitter::Identity
    include Twitter::Creatable

    # @return [String]
    attr_reader :name, :audience_type, :list_type, :partner_source

    # @return [Integer]
    attr_reader :audience_size

    # @return [Array<String>]
    attr_reader :targetable_types, :reasons_not_targetable

    predicate_attr_reader :deleted, :targetable
  end
end
