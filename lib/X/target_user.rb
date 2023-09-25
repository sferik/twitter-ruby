require "X/basic_user"

module X
  class TargetUser < X::BasicUser
    predicate_attr_reader :followed_by
  end
end
