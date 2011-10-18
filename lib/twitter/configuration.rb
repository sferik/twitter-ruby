require 'active_support/core_ext/enumerable'
require 'twitter/base'
require 'twitter/size'

module Twitter
  class Configuration < Twitter::Base
    attr_reader :photo_sizes
    lazy_attr_reader :characters_reserved_per_media, :max_media_per_upload,
      :non_username_paths, :photo_size_limit, :short_url_length, :short_url_length_https

    def initialize(attributes={})
      attributes = attributes.dup
      @photo_sizes = attributes.delete('photo_sizes').each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.new(value)
      end unless attributes['photo_sizes'].nil?
      super(attributes)
    end

  end
end
