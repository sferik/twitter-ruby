require 'twitter/identity'

module Twitter
  module Media
    class Photo < Twitter::Identity
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
    end
  end
end
