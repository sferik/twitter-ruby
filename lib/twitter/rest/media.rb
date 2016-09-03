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
        raise(Twitter::Error::UnacceptableIO.new) unless media.respond_to?(:to_io)
        base_url = 'https://upload.twitter.com'
        path = '/1.1/media/upload.json'
        conn = connection.dup
        conn.url_prefix = base_url
        headers = Twitter::Headers.new(self, :post, base_url + path, options).request_headers
        options[:media] = media
        conn.post(path, options) { |request| request.headers.update(headers) }.env.body[:media_id]
      end
    end
  end
end
