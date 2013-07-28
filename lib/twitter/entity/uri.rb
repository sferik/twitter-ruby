require 'twitter/entity'

module Twitter
  class Entity
    class URI < Twitter::Entity

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

    Uri = URI
    URL = URI
    Url = URI
  end
end
