require 'active_support/core_ext/enumerable'
require 'twitter/base'
require 'twitter/size'

module Twitter
  class Photo < Twitter::Base
    lazy_attr_reader :display_url, :expanded_url, :id, :indices, :media_url,
      :media_url_https, :url

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def sizes
      @sizes ||= Array(@attributes['sizes']).each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.new(value)
      end
    end

  end
end
