require 'twitter/base'
require 'twitter/creatable'

module Twitter
  module Action
    class Tweet < Twitter::Base
      include Twitter::Creatable
      attr_reader :max_position, :min_position

      # @return [Array<Twitter::User>]
      def sources
        @sources = Array(@attrs[:sources]).map do |user|
          Twitter::User.fetch_or_new(user)
        end
      end

    end
    Status = Tweet
  end
end
