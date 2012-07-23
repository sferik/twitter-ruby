require 'twitter/factory'
require 'twitter/media/photo'

module Twitter
  class MediaFactory < Twitter::Factory

    # Instantiates a new media object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [Twitter::Media]
    def self.fetch_or_new(attrs={})
      super(:type, Twitter::Media, attrs)
    end

  end
end
