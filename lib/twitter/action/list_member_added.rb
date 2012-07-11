require 'twitter/base'
require 'twitter/creatable'
require 'twitter/list'
require 'twitter/user'

module Twitter
  module Action
    class ListMemberAdded < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position, :target_objects

      # A collection of users who added a user to a list
      #
      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          Twitter::User.fetch_or_create(user)
        end
      end

      # A collection of lists that were added to
      #
      # @return [Array<Twitter::List>]
      def target_objects
        @target_objects = Array(@attrs[:target_objects]).map do |list|
          Twitter::List.fetch_or_create(list)
        end
      end

      # A collection of users who were added to a list
      #
      # @return [Array<Twitter::User>]
      def targets
        @targets = Array(@attrs[:targets]).map do |user|
          Twitter::User.fetch_or_create(user)
        end
      end

    end
  end
end
