require "twitter/factory"
require "twitter/media/animated_gif"
require "twitter/media/photo"
require "twitter/media/video"

module Twitter
  # Factory for creating media objects based on type
  class MediaFactory < Twitter::Factory
    class << self
      # Constructs a new media object
      #
      # @api public
      # @example
      #   Twitter::MediaFactory.new(type: "photo", id: 123)
      # @param attrs [Hash] The attributes hash with a :type key
      # @raise [IndexError] Error raised when argument is missing a :type key
      # @return [Twitter::Media]
      def new(attrs = {})
        super(:type, Media, attrs)
      end
    end
  end
end
