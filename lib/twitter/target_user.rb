require "twitter/basic_user"

module Twitter
  # Represents the target user in a relationship
  class TargetUser < BasicUser
    predicate_attr_reader :followed_by
  end
end
