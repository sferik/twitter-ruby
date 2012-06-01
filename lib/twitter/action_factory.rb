require 'twitter/favorite'
require 'twitter/follow'
require 'twitter/inflector'
require 'twitter/list_member_added'
require 'twitter/mention'
require 'twitter/reply'
require 'twitter/retweet'

module Twitter
  class ActionFactory
    extend Twitter::Inflector

    # Instantiates a new action object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an 'action' key.
    # @return [Twitter::Favorite, Twitter::Follow, Twitter::ListMemberAdded, Twitter::Mention, Twitter::Reply, Twitter::Retweet]
    def self.new(action={})
      type = action.delete('action')
      if type
        Twitter.const_get(camelize(type).to_sym).new(action)
      else
        raise ArgumentError, "argument must have an 'action' key"
      end
    end

  end
end
