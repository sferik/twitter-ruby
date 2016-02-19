require 'twitter/base'
require 'twitter/creatable'

module Twitter
  module Streaming
    class Event < Twitter::Base
      include Twitter::Creatable

      LIST_EVENTS = [
        :list_created, :list_destroyed, :list_updated,
        :list_member_added, :list_member_removed,
        :list_user_subscribed, :list_user_unsubscribed
      ].freeze

      TWEET_EVENTS = [
        :favorite, :unfavorite, :favorited_retweet, :retweeted_retweet
      ].freeze

      object_attr_reader :User, :source
      object_attr_reader :User, :target
      define_predicate_method :target_object

      # @return [Twitter::List, Twitter::Tweet, Twitter::NullObject]
      def target_object
        data = @attrs[:target_object]

        if LIST_EVENTS.include?(name)
          Twitter::List.new(data)
        elsif TWEET_EVENTS.include?(name)
          Twitter::Tweet.new(data)
        else
          Twitter::NullObject.new
        end
      end
      memoize :target_object

      # @return [Symbol]
      def name
        @attrs.fetch(:event, :'').to_sym
      end
      memoize :name
    end
  end
end
