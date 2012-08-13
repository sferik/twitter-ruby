require 'twitter/action/tweet'

module Twitter
  module Action
    class Retweet < Twitter::Action::Tweet

      # A collection of retweets
      #
      # @return [Array<Twitter::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          Twitter::Tweet.fetch_or_new(tweet)
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
