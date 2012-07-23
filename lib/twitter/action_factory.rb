require 'twitter/action/favorite'
require 'twitter/action/follow'
require 'twitter/action/list_member_added'
require 'twitter/action/mention'
require 'twitter/action/reply'
require 'twitter/action/retweet'
require 'twitter/factory'

module Twitter
  class ActionFactory < Twitter::Factory

    # Instantiates a new action object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing an :action key.
    # @return [Twitter::Action]
    def self.fetch_or_new(attrs={})
      super(:action, Twitter::Action, attrs)
    end

  end
end
