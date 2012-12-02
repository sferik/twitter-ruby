require 'twitter/base'
require 'twitter/creatable'

module Twitter
  module Action
    class Follow < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position, :target_objects

      # A collection of users who followed a user
      #
      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          Twitter::User.fetch_or_new(user)
        end
      end

      # A collection containing the followed user
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
