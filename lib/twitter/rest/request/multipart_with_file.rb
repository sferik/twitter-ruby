require 'faraday'

module Twitter
  module REST
    module Request
      class MultipartWithFile < Faraday::Middleware
        CONTENT_TYPE = 'Content-Type'
        GIF_REGEX = /\.gif$/i
        JPEG_REGEX = /\.jpe?g/i
        PNG_REGEX = /\.png$/i

        def call(request)
          request.body.each do |key, value|
            if value.respond_to?(:to_io)
              request.body[key] = Faraday::UploadIO.new(value, mime_type(value.path), value.path)
            end
          end if request.body.is_a?(::Hash)
          @app.call(request)
        end

      private

        def mime_type(path)
          case path
          when GIF_REGEX
            'image/gif'
          when JPEG_REGEX
            'image/jpeg'
          when PNG_REGEX
            'image/png'
          else
            'application/octet-stream'
          end
        end
      end
    end
  end
end

Faraday::Request.register_middleware :multipart_with_file => Twitter::REST::Request::MultipartWithFile
