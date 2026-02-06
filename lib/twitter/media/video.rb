require "memoizable"
require "twitter/identity"
require "twitter/media/video_info"

module Twitter
  module Media
    # Represents a Twitter video media object
    class Video < Twitter::Identity
      include Memoizable

      # The indices of this media in the text
      #
      # @api public
      # @example
      #   video.indices
      # @return [Array<Integer>]
      attr_reader :indices

      # The media type
      #
      # @api public
      # @example
      #   video.type
      # @return [String]
      attr_reader :type

      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns a hash of video sizes
      #
      # @api public
      # @example
      #   video.sizes
      # @return [Hash{Symbol => Twitter::Size}]
      def sizes
        @attrs.fetch(:sizes, []).each_with_object({}) do |(key, value), object|
          object[key] = Size.new(value)
        end
      end
      memoize :sizes

      # Returns video info
      #
      # @api public
      # @example
      #   video.video_info
      # @return [Twitter::Media::VideoInfo]
      def video_info
        VideoInfo.new(@attrs[:video_info]) unless @attrs[:video_info].nil?
      end
      memoize :video_info
    end
  end
end
