require 'active_support/core_ext/enumerable'
require 'twitter/base'
require 'twitter/size'

module Twitter
  class Configuration < Twitter::Base
    lazy_attr_reader :characters_reserved_per_media, :max_media_per_upload,
      :non_username_paths, :photo_size_limit, :short_url_length, :short_url_length_https

    # Returns an array of photo sizes
    #
    # @return [Array<Twitter::Size>]
    def photo_sizes
      @photo_sizes ||= Array(@attrs['photo_sizes']).each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.new(value)
      end
    end

  end
end
