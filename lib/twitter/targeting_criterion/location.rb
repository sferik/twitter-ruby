module Twitter
  class TargetingCriterion
    class Location < Twitter::Base

      # @return [String]
      attr_reader :name, :location_type, :targeting_type, :targeting_value
    end
  end
end
