require 'twitter/identity'
require 'twitter/utils'

module Twitter
  class BasicUser < Twitter::Identity
    # @return [String]
    attr_reader :screen_name
    deprecate_alias :handle, :screen_name
    deprecate_alias :username, :screen_name
    deprecate_alias :user_name, :screen_name
    predicate_attr_reader :following
  end
end
