require 'twitter/base'
require 'twitter/creatable'

module Twitter
  module Action
    class Mention < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position

      # A collection of users who mentioned a user
      #
      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          Twitter::User.fetch_or_new(user)
        end
      end

      # The user who mentioned a user
      #
      # @return [Twitter::User]
      def source
        @source = sources.first
      end

      # A collection of tweets that mention a user
      #
      # @return [Array<Twitter::Tweet>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |tweet|
          Twitter::Tweet.fetch_or_new(tweet)
        end
      end

      # A collection containing the mentioned user
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
