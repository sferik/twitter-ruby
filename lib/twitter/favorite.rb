require 'twitter/action'
require 'twitter/status'
require 'twitter/user'

module Twitter
  class Favorite < Twitter::Action
    lazy_attr_reader :target_objects

    # A collection of users who favorited a status
    #
    # @return [Array<Twitter::User>]
    def sources
      @sources = Array(@attrs['sources']).map do |user|
        Twitter::User.new(user)
      end
    end

    # A collection containing the favorited status
    #
    # @return [Array<Twitter::Status>]
    def targets
      @targets = Array(@attrs['targets']).map do |status|
        Twitter::Status.new(status)
      end
    end

  end
end
