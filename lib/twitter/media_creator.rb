require 'twitter/creator'
require 'twitter/media/photo'

module Twitter
  class MediaCreator < Twitter::Creator

    # Construct a new media object
    #
    # @param attrs [Hash]
    # @raise [ArgumentError] Error raised when supplied argument is missing a :type key.
    # @return [Twitter::Media]
    def self.new(attrs={})
      super(:type, Twitter::Media, attrs)
    end

  end
end
