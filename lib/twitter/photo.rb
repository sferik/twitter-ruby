require 'twitter/base'
require 'twitter/size'

module Twitter
  class Photo < Twitter::Base
    attr_reader :display_url, :expanded_url, :id, :indices, :media_url,
      :media_url_https, :url

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def sizes
      if @sizes
        sizes = {}
        @sizes.each do |key, value|
          sizes[key] = Twitter::Size.new(value)
        end
        sizes
      end
    end
  end
end
