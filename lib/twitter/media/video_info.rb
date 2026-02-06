require "memoizable"
require "twitter/variant"

module Twitter
  module Media
    # Contains video metadata information
    class VideoInfo < Twitter::Base
      include Memoizable

      # The aspect ratio of the video
      #
      # @api public
      # @example
      #   video_info.aspect_ratio
      # @return [Array<Integer>]
      attr_reader :aspect_ratio

      # The duration of the video in milliseconds
      #
      # @api public
      # @example
      #   video_info.duration_millis
      # @return [Integer]
      attr_reader :duration_millis

      # Returns an array of video variants
      #
      # @api public
      # @example
      #   video_info.variants
      # @return [Array<Twitter::Variant>]
      def variants
        @attrs.fetch(:variants, []).collect do |variant|
          Variant.new(variant)
        end
      end
      memoize :variants
    end
  end
end
