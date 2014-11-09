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
      # @return [Integer] The uploaded media ID.
      # @param media [File, Hash] A File object with your picture (PNG, JPEG or GIF)
      # @param options [Hash] A customizable set of options.
      def upload(media, options = {})
        url = 'https://upload.twitter.com/1.1/media/upload.json'
        headers = Twitter::Headers.new(self, :post, url, options).request_headers
        HTTP.with(headers).post(url, form: options.merge(media: media)).parse['media_id']
      end
    end
  end
end
