require "memoizable"
require "X/variant"

module X
  module Media
    class VideoInfo < X::Base
      include Memoizable

      # @return [Array<Integer]
      attr_reader :aspect_ratio

      # @return [Integer]
      attr_reader :duration_millis

      # Returns an array of video variants
      #
      # @return [Array<X::Variant>]
      def variants
        @attrs.fetch(:variants, []).collect do |variant|
          Variant.new(variant)
        end
      end
      memoize :variants
    end
  end
end
