require 'twitter/action/status'

module Twitter
  module Action
    class Favorite < Twitter::Action::Status
      attr_reader :target_objects

      # A collection containing the favorited status
      #
      # @return [Array<Twitter::Status>]
      def targets
        @targets = Array(@attrs[:targets]).map do |status|
          Twitter::Status.fetch_or_new(status)
        end
      end

    end
  end
end
