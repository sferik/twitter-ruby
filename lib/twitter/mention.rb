require 'twitter/action'
require 'twitter/status'
require 'twitter/user'

module Twitter
  class Mention < Twitter::Action

    # A collection of users who mentioned a user
    #
    # @return [Array<Twitter::User>]
    def sources
      @sources = Array(@attrs['sources']).map do |user|
        Twitter::User.new(user)
      end
    end

    # The user who mentioned a user
    #
    # @return [Twitter::User]
    def source
      @source = sources.first
    end

    # A collection of statuses that mention a user
    #
    # @return [Array<Twitter::Status>]
    def target_objects
      @target_objects = Array(@attrs['target_objects']).map do |status|
        Twitter::Status.new(status)
      end
    end

    # A collection containing the mentioned user
    #
    # @return [Array<Twitter::User>]
    def targets
      @targets = Array(@attrs['targets']).map do |user|
        Twitter::User.new(user)
      end
    end

  end
end
