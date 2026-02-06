module Twitter
  module Streaming
    # Represents a streaming event from the Twitter API
    #
    # @api public
    class Event
      # Event names for list-related events
      LIST_EVENTS = %i[
        list_created list_destroyed list_updated list_member_added
        list_member_added list_member_removed list_user_subscribed
        list_user_subscribed list_user_unsubscribed list_user_unsubscribed
      ].freeze

      # Event names for tweet-related events
      TWEET_EVENTS = %i[
        favorite unfavorite quoted_tweet
      ].freeze

      # Returns the event name
      #
      # @api public
      # @example
      #   event.name
      # @return [Symbol]

      # Returns the source user
      #
      # @api public
      # @example
      #   event.source
      # @return [Twitter::User]

      # Returns the target user
      #
      # @api public
      # @example
      #   event.target
      # @return [Twitter::User]

      # Returns the target object
      #
      # @api public
      # @example
      #   event.target_object
      # @return [Twitter::Tweet, Twitter::List, nil]
      attr_reader :name, :source, :target, :target_object

      # Initializes a new Event object
      #
      # @api public
      # @example
      #   Twitter::Streaming::Event.new(data)
      # @param data [Hash]
      # @return [Twitter::Streaming::Event]
      def initialize(data)
        @name = data[:event].to_sym
        @source = Twitter::User.new(data[:source])
        @target = Twitter::User.new(data[:target])
        @target_object = target_object_factory(@name, data[:target_object])
      end

    private

      # Builds the target object based on event type
      #
      # @api private
      # @return [Twitter::Tweet, Twitter::List, nil]
      def target_object_factory(event_name, data)
        if LIST_EVENTS.include?(event_name)
          Twitter::List.new(data)
        elsif TWEET_EVENTS.include?(event_name)
          Twitter::Tweet.new(data)
        end
      end
    end
  end
end
