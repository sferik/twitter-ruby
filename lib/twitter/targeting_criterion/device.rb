module Twitter
  class TargetingCriterion
    class Device < Twitter::Base

      # @return [String]
      attr_reader :manufacturer, :name, :platform, :targeting_type, :targeting_value
    end
  end
end
