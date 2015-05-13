require 'twitter/base'

module Twitter
  class TargetingCriterion
    class PlatformVersion < Twitter::Base

      # @return [String]
      attr_reader :name, :number, :platform, :targeting_type, :targeting_value
    end
  end
end
