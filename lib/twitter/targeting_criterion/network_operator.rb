module Twitter
  class TargetingCriterion
    class NetworkOperator < Twitter::Base

      # @return [String]
      attr_reader :country_code, :name, :targeting_type, :targeting_value
    end
  end
end
