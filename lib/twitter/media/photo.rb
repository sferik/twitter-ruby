require "memoizable"
require "twitter/identity"

module Twitter
  # Namespace for Twitter media types
  module Media
    # Represents a Twitter photo media object
    class Photo < Twitter::Identity
      include Memoizable

      # The indices of this media in the text
      #
      # @api public
      # @example
      #   photo.indices
      # @return [Array<Integer>]
      attr_reader :indices

      # The media type
      #
      # @api public
      # @example
      #   photo.type
      # @return [String]
      attr_reader :type

      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns a hash of photo sizes
      #
      # @api public
      # @example
      #   photo.sizes
      # @return [Hash{Symbol => Twitter::Size}]
      def sizes
        @attrs.fetch(:sizes, []).each_with_object({}) do |(key, value), object|
          object[key] = Size.new(value)
        end
      end
      memoize :sizes
    end
  end
end
