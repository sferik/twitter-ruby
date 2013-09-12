require 'twitter/base'

module Twitter
  class Configuration < Twitter::Base
    attr_reader :characters_reserved_per_media, :max_media_per_upload,
      :non_username_paths, :photo_size_limit, :short_url_length, :short_url_length_https
    alias short_uri_length short_url_length
    alias short_uri_length_https short_url_length_https

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def photo_sizes
      memoize(:photo_sizes) do
        Array(@attrs[:photo_sizes]).inject({}) do |object, (key, value)|
          object[key] = Twitter::Size.new(value)
          object
        end
      end
    end

  end
end
