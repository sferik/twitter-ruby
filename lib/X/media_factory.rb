require "X/factory"
require "X/media/animated_gif"
require "X/media/photo"
require "X/media/video"

module X
  class MediaFactory < X::Factory
    class << self
      # Construct a new media object
      #
      # @param attrs [Hash]
      # @raise [IndexError] Error raised when supplied argument is missing a :type key.
      # @return [X::Media]
      def new(attrs = {})
        super(:type, Media, attrs)
      end
    end
  end
end
