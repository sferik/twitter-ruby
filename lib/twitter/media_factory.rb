require 'twitter/photo'

module Twitter
  class MediaFactory
    def self.new(media)
      type = media['type']
      if type
        Twitter.const_get(type.capitalize.to_sym).new(media)
      else
        raise ArgumentError, "argument must have a type key"
      end
    end
  end
end
