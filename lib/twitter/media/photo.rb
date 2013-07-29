require 'twitter/identity'

module Twitter
  module Media
    class Photo < Twitter::Identity
      attr_reader :indices
      uri_attr_reader :display_uri, :expanded_uri, :media_uri, :media_uri_https, :uri

      # Returns an array of photo sizes
      #
      # @return [Array<Twitter::Size>]
      def sizes
        @sizes ||= Array(@attrs[:sizes]).each_with_object({}) do |(key, value), object|
          object[key] = Twitter::Size.new(value)
        end
      end

    end
  end
end
