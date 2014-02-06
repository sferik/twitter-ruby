require 'twitter/base'

module Twitter
  class Configuration < Twitter::Base
    attr_reader :characters_reserved_per_media, :max_media_per_upload,
                :non_username_paths, :photo_size_limit, :short_url_length,
                :short_url_length_https
    alias_method :short_uri_length, :short_url_length
    alias_method :short_uri_length_https, :short_url_length_https

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]

    def characters_reserved_per_media
   @attrs.characters_reserved_per_media
end
def max_media_per_upload
   @attrs.max_media_per_upload
end
def non_username_paths
   @attrs.non_username_paths
end
def photo_size_limit
   @attrs.photo_size_limit
end
def short_url_length
   @attrs.short_url_length
end
def short_url_length_https
   @attrs.short_url_length_https
end

    def photo_sizes
      Array(@attrs[:photo_sizes]).inject({}) do |object, (key, value)|
        object[key] = Size.new(value)
        object
      end
    end
    memoize :photo_sizes
  end
end
