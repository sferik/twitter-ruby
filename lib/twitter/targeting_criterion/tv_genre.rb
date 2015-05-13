require 'twitter/identity'

module Twitter
  class TargetingCriterion
    class TVGenre < Twitter::Identity

      # @return [String]
      attr_reader :name
    end
  end
end
