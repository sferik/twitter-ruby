require 'twitter/action'
require 'twitter/user'

module Twitter
  class Follow < Twitter::Action
    lazy_attr_reader :target_objects

    # A collection of users who followed a user
    #
    # @return [Array<Twitter::User>]
    def sources
      @sources = Array(@attrs['sources']).map do |user|
        Twitter::User.new(user)
      end
    end

    # A collection containing the followed user
    #
    # @return [Array<Twitter::User>]
    def targets
      @targets = Array(@attrs['targets']).map do |user|
        Twitter::User.new(user)
      end
    end

  end
end
