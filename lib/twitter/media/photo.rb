require 'twitter/identity'

module Twitter
  module Media
    class Photo < Twitter::Identity
      attr_reader :display_url, :expanded_url, :indices, :media_url,
        :media_url_https, :url

      # Returns an array of photo sizes
      #
      # @return [Array<Twitter::Size>]
      def sizes
        @sizes ||= Array(@attrs[:sizes]).each_with_object({}) do |(key, value), object|
          object[key] = Twitter::Size.fetch_or_new(value)
        end
      end

    end
  end
end
