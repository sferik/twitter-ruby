require 'active_support/core_ext/enumerable'
require 'twitter/base'
require 'twitter/size'

module Twitter
  class Configuration < Twitter::Base
    attr_reader :characters_reserved_per_media, :max_media_per_upload,
      :non_username_paths, :photo_size_limit, :photo_sizes, :short_url_length,
      :short_url_length_https

    def initialize(configuration={})
      @characters_reserved_per_media = configuration['characters_reserved_per_media']
      @max_media_per_upload = configuration['max_media_per_upload']
      @non_username_paths = configuration['non_username_paths']
      @photo_size_limit = configuration['photo_size_limit']
      @photo_sizes = configuration['photo_sizes'].each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.new(value)
      end unless configuration['photo_sizes'].nil?
      @short_url_length = configuration['short_url_length']
      @short_url_length_https = configuration['short_url_length_https']
    end
  end
end
