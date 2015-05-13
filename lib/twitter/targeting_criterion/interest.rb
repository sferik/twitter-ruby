module Twitter
  class TargetingCriterion
    class Interest < Twitter::Base

      # @return [String]
      attr_reader :name, :targeting_type, :targeting_value
    end
  end
end
