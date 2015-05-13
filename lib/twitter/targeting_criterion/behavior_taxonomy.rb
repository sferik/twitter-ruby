require 'twitter/identity'

module Twitter
  class TargetingCriterion
    class BehaviorTaxonomy < Twitter::Identity

      # @return [String]
      attr_reader :name, :number, :platform, :targeting_type, :targeting_value
    end
  end
end
