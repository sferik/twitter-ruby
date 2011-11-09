require 'twitter/action'
require 'twitter/status'
require 'twitter/user'

module Twitter
  class Reply < Twitter::Action

    # A collection of users who replies to a user
    #
    # @return [Array<Twitter::User>]
    def sources
      @sources = Array(@attrs['sources']).map do |user|
        Twitter::User.new(user)
      end
    end

    # A collection of statuses that reply to a user
    #
    # @return [Array<Twitter::Status>]
    def target_objects
      @target_objects = Array(@attrs['target_objects']).map do |status|
        Twitter::Status.new(status)
      end
    end

    # A collection that contains the replied-to status
    #
    # @return [Array<Twitter::Status>]
    def targets
      @targets = Array(@attrs['targets']).map do |status|
        Twitter::Status.new(status)
      end
    end

  end
end
