module Twitter
  class TargetingCriterion
    class AppStoreCategory < Twitter::Base

      # @return [String]
      attr_reader :name, :os_type, :targeting_type, :targeting_value
    end
  end
end
