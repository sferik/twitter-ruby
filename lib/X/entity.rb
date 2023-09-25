require "X/base"

module X
  class Entity < X::Base
    # @return [Array<Integer>]
    attr_reader :indices
  end
end
