require 'twitter/identity'
require 'twitter/media/video_info'

module Twitter
  module Media
    class Video < Twitter::Identity
      # @return [Array<Integer>]
      attr_reader :indices
      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns an array of photo sizes
      #
      # @return [Array<Twitter::Size>]
      def sizes
        object = {}
        @attrs.fetch(:sizes, []).each do |(key, value)|
          object[key] = Size.new(value)
        end
        object
      end
      memoize :sizes

      # Returns video info
      #
      # @return [Twitter::Media::VideoInfo]
      def video_info
        VideoInfo.new(@attrs[:video_info]) unless @attrs[:video_info].nil?
      end
      memoize :video_info
    end
  end
end
