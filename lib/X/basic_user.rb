require "X/identity"
require "X/utils"

module X
  class BasicUser < X::Identity
    # @return [String]
    attr_reader :screen_name

    predicate_attr_reader :following
  end
end
