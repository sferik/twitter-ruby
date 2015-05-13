require 'twitter/identity'

module Twitter
  class TargetingCriterion
    class TVShow < Twitter::Identity

      # @return [Integer]
      attr_reader :estimated_users

      # @return [String]
      attr_reader :genre, :name
    end
  end
end
