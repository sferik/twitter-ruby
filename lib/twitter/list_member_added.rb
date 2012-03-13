require 'twitter/action'
require 'twitter/list'
require 'twitter/user'

module Twitter
  class ListMemberAdded < Twitter::Action
    lazy_attr_reader :target_objects

    # A collection of users who added to the list
    #
    # @return [Array<Twitter::User>]
    def sources
      @sources = Array(@attrs['sources']).map do |user|
        Twitter::User.new(user)
      end
    end

    # A collection of lists that were added to
    #
    # @return [Array<Twitter::List>]
    def target_objects
      @target_objects = Array(@attrs['target_objects']).map do |list|
        Twitter::List.new(list)
      end
    end

    # A collection of users who were added to the list
    #
    # @return [Array<Twitter::User>]
    def targets
      @targets = Array(@attrs['targets']).map do |user|
        Twitter::User.new(user)
      end
    end
  end
end
