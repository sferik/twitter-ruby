require 'twitter/base'
require 'twitter/creatable'
require 'twitter/status'
require 'twitter/user'

module Twitter
  module Action
    class Retweet < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position

      # A collection of users who retweeted a user
      #
      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs['sources']).map do |user|
          Twitter::User.get_or_new(user)
        end
      end

      # A collection of retweets
      #
      # @return [Array<Twitter::Status>]
      def target_objects
        @target_objects = Array(@attrs['target_objects']).map do |status|
          Twitter::Status.get_or_new(status)
        end
      end

      # A collection containing the retweeted user
      #
      # @return [Array<Twitter::User>]
      def targets
        @targets = Array(@attrs['targets']).map do |user|
          Twitter::User.get_or_new(user)
        end
      end

    end
  end
end
