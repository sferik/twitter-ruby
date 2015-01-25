require 'twitter/streaming/follow'
require 'twitter/streaming/user'

module Twitter
  module Streaming
    class Info < Twitter::Base
      attr_reader :delimited, :include_followings_activity, :include_user_changes, :replies, :with

      # Initializes a new Site stream info
      #
      # @param attrs [Hash]
      # @return [Twitter::Streaming::Info]
      def initialize(attrs)
        super(attrs[:info])
      end

      # Returns which users are being streamed over the site stream connection
      #
      # @return [Array<Twitter::Streaming::User>]
      def users
        @attrs.fetch(:users, []).map do |object|
          Twitter::Streaming::User.new(object)
        end
      end
      memoize :users

      # Returns the users and their followers being streamed
      #
      # @return [Array<Twitter::Streaming::Follow>]
      def follows
        @attrs.fetch(:follows, []).map do |object|
          Twitter::Streaming::Follow.new(object)
        end
      end
      memoize :follows
    end
  end
end
