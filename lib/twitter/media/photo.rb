require 'twitter/identity'

module Twitter
  module Media
    class Photo < Twitter::Identity
      attr_reader :indices

      # Returns an array of photo sizes
      #
      # @return [Array<Twitter::Size>]
      def sizes
        @sizes ||= Array(@attrs[:sizes]).each_with_object({}) do |(key, value), object|
          object[key] = Twitter::Size.new(value)
        end
      end

      # @return [URI]
      def display_uri
        @display_uri ||= ::URI.parse(@attrs[:display_url]) if display_uri?
      end
      alias display_url display_uri

      # @return [Boolean]
      def display_uri?
        !!@attrs[:display_url]
      end
      alias display_url? display_uri?

      # @return [URI]
      def expanded_uri
        @expanded_uri ||= ::URI.parse(@attrs[:expanded_url]) if expanded_uri?
      end
      alias expanded_url expanded_uri

      # @return [Boolean]
      def expanded_uri?
        !!@attrs[:expanded_url]
      end
      alias expanded_url? expanded_uri?

      # @return [URI]
      def media_uri
        @media_uri ||= ::URI.parse(@attrs[:media_url]) if media_uri?
      end
      alias media_url media_uri

      # @return [Boolean]
      def media_uri?
        !!@attrs[:media_url]
      end
      alias media_url? media_uri?

      # @return [URI]
      def media_uri_https
        @media_uri_https ||= ::URI.parse(@attrs[:media_url_https]) if media_uri_https?
      end
      alias media_url_https media_uri_https

      # @return [Boolean]
      def media_uri_https?
        !!@attrs[:media_url_https]
      end
      alias media_url_https? media_uri_https?

      # @return [URI]
      def uri
        @uri ||= ::URI.parse(@attrs[:url]) if uri?
      end
      alias url uri

      # @return [Boolean]
      def uri?
        !!@attrs[:url]
      end
      alias url? uri?

    end
  end
end
