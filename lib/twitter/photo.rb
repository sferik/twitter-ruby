require 'twitter/identifiable'
require 'twitter/size'

module Twitter
  class Photo < Twitter::Identifiable
    lazy_attr_reader :display_url, :expanded_url, :indices, :media_url,
      :media_url_https, :url

    # @param other [Twitter::Photo]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Array<Twitter::Size>]
    def sizes
      @sizes ||= Array(@attrs['sizes']).inject({}) do |object, (key, value)|
        object[key] = Twitter::Size.new(value)
        object
      end
    end

  end
end
