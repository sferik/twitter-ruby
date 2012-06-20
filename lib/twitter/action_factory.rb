require 'twitter/action/favorite'
require 'twitter/action/follow'
require 'twitter/action/list_member_added'
require 'twitter/action/mention'
require 'twitter/action/reply'
require 'twitter/action/retweet'
require 'twitter/inflector'

module Twitter
  class ActionFactory
    extend Twitter::Inflector

    # Instantiates a new action object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an 'action' key.
    # @return [Twitter::Action::Favorite, Twitter::Action::Follow, Twitter::Action::ListMemberAdded, Twitter::Action::Mention, Twitter::Action::Reply, Twitter::Action::Retweet]
    def self.new(action={})
      type = action.delete('action')
      if type
        Twitter::Action.const_get(camelize(type).to_sym).get_or_new(action)
      else
        raise ArgumentError, "argument must have an 'action' key"
      end
    end

  end
end
