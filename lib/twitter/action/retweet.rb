require 'twitter/action/status'

module Twitter
  module Action
    class Retweet < Twitter::Action::Status

      # A collection of retweets
      #
      # @return [Array<Twitter::Status>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |status|
          Twitter::Status.fetch_or_new(status)
        end
      end

      # A collection containing the retweeted user
      #
      # @return [Array<Twitter::User>]
      def targets
        @targets = Array(@attrs[:targets]).map do |user|
          Twitter::User.fetch_or_new(user)
        end
      end

    end
  end
end
