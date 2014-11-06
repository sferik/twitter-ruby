require 'twitter/error'
require 'twitter/headers'
require 'twitter/rest/utils'

module Twitter
  module REST
    module Media
      # Uploads media to attach to a tweet
      #
      # @see https://dev.twitter.com/rest/public/uploading-media-multiple-photos
      # @rate_limited No
      # @authentication Requires user context
      # @raise [Twitter::Error::Unauthorized] Error raised when supplied user credentials are not valid.
      # @raise [Twitter::Error::UnacceptableIO] Error when the IO object for the media argument does not have a to_io method.
      # @return [Integer] The uploaded media ID.
      # @param media [File, Hash] A File object with your picture (PNG, JPEG or GIF)
      # @param options [Hash] A customizable set of options.
      def upload(media, options = {})
        fail(Twitter::Error::UnacceptableIO.new) unless media.respond_to?(:to_io)
        url = 'https://upload.twitter.com/1.1/media/upload.json'
        headers = Twitter::Headers.new(self, :post, url, options).request_headers
        HTTP.with(headers).post(url, :form => options).parse['media_id']
      end
    end
  end
end
