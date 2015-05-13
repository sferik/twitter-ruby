require 'twitter/identity'

module Twitter
  class TargetingCriterion
    class Behavior < Twitter::Identity

      # @return [Integer]
      attr_reader :audience_size

      # @return [String]
      attr_reader :behavior_taxonomy_id, :name, :partner_source

      # @return [Array<String>]
      attr_reader :targetable_types
    end
  end
end
