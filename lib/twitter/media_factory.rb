require 'twitter/core_ext/string'
require 'twitter/media/photo'

module Twitter
  class MediaFactory

    # Instantiates a new media object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [Twitter::Photo]
    def self.fetch_or_store(attrs={})
      if type = attrs.delete(:type)
        Twitter.const_get(type.camelize.to_sym).fetch_or_store(attrs)
      else
        raise ArgumentError, "argument must have a :type key"
      end
    end

  end
end
