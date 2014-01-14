require 'twitter/identity'

module Twitter
  module Media
    class Photo < Twitter::Identity
      attr_reader :indices
      display_uri_attr_reader
      uri_attr_reader :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns an array of photo sizes
      #
      # @return [Array<Twitter::Size>]
      def sizes
        Array(@attrs[:sizes]).inject({}) do |object, (key, value)|
          object[key] = Size.new(value)
          object
        end
      end
      memoize :sizes
    end
  end
end
