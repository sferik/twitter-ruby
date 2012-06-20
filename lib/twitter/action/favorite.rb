require 'twitter/base'
require 'twitter/creatable'
require 'twitter/status'
require 'twitter/user'

module Twitter
  module Action
    class Favorite < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position, :target_objects

      # A collection of users who favorited a status
      #
      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs['sources']).map do |user|
          Twitter::User.get_or_new(user)
        end
      end

      # A collection containing the favorited status
      #
      # @return [Array<Twitter::Status>]
      def targets
        @targets = Array(@attrs['targets']).map do |status|
          Twitter::Status.get_or_new(status)
        end
      end

    end
  end
end
