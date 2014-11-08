require 'faraday'

module Twitter
  module REST
    class Request
      class MultipartWithFile < Faraday::Middleware
        CONTENT_TYPE = 'Content-Type'.freeze
        BMP_REGEX = /\.bmp/i
        GIF_REGEX = /\.gif$/i
        JPEG_REGEX = /\.jpe?g/i
        PNG_REGEX = /\.png$/i
        WEBP_REGEX = /\.webp/i

        def call(request)
          if request.body.is_a?(::Hash)
            request.body.each do |key, value|
              next unless value.respond_to?(:to_io)
              request.body[key] = Faraday::UploadIO.new(value, mime_type(value.path), value.path)
            end
          end
          @app.call(request)
        end

      private

        def mime_type(path)
          case path
          when BMP_REGEX
            'image/bmp'
          when GIF_REGEX
            'image/gif'
          when JPEG_REGEX
            'image/jpeg'
          when PNG_REGEX
            'image/png'
          when WEBP_REGEX
            'image/webp'
          else
            'application/octet-stream'
          end
        end
      end
    end
  end
end

Faraday::Request.register_middleware twitter_multipart_with_file: Twitter::REST::Request::MultipartWithFile
