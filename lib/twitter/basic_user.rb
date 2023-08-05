require "twitter/identity"
require "twitter/utils"

module Twitter
  class BasicUser < Twitter::Identity
    # @return [String]
    attr_reader :username

    predicate_attr_reader :following
  end
end
