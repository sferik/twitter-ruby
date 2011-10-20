require 'active_support/core_ext/enumerable'
require 'twitter/base'
require 'twitter/size'

module Twitter
  class Photo < Twitter::Base
    lazy_attr_reader :display_url, :expanded_url, :id, :indices, :media_url,
      :media_url_https, :url

    # @param other [Twiter::Photo]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Array<Twitter::Size>]
    def sizes
      @sizes ||= Array(@attrs['sizes']).each_with_object({}) do |(key, value), object|
        object[key] = Twitter::Size.new(value)
      end
    end

  end
end
