require 'twitter/base'

module Twitter
  class TargetingSuggestion < Twitter::Base

    # @return [String]
    attr_reader :suggestion_type, :suggestion_value
  end
end
