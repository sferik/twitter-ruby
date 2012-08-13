require 'twitter/action/tweet'

module Twitter
  module Action
    class Reply < Twitter::Action::Tweet

      # A collection of tweets that reply to a user
      #
      # @return [Array<Twitter::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          Twitter::Tweet.fetch_or_new(tweet)
        end
      end

      # A collection that contains the replied-to tweets
      #
      # @return [Array<Twitter::Tweet>]
      def targets
        @targets = Array(@attrs[:targets]).map do |tweet|
          Twitter::Tweet.fetch_or_new(tweet)
        end
      end

    end
  end
end
