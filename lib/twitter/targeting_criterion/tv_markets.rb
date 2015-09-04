require 'twitter/identity'

module Twitter
  class TargetingCriterion
    class TVMarket < Twitter::Identity

      # @return [String]
      attr_reader :country_code, :locale, :name
    end
  end
end
