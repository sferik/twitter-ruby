require "memoizable"
require "X/identity"
require "X/media/video_info"

module X
  module Media
    class Video < X::Identity
      include Memoizable

      # @return [Array<Integer>]
      attr_reader :indices

      # @return [String]
      attr_reader :type

      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns an array of photo sizes
      #
      # @return [Array<X::Size>]
      def sizes
        @attrs.fetch(:sizes, []).each_with_object({}) do |(key, value), object|
          object[key] = Size.new(value)
        end
      end
      memoize :sizes

      # Returns video info
      #
      # @return [X::Media::VideoInfo]
      def video_info
        VideoInfo.new(@attrs[:video_info]) unless @attrs[:video_info].nil?
      end
      memoize :video_info
    end
  end
end
