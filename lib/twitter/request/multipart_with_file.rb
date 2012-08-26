require 'faraday'

module Twitter
  module Request
    class MultipartWithFile < Faraday::Middleware
      CONTENT_TYPE = 'Content-Type'.freeze
      class << self
        attr_accessor :mime_type
      end
      self.mime_type = 'multipart/form-data'.freeze

      def call(env)
        if env[:body].is_a?(Hash)
          env[:body].each do |key, value|
            if value.respond_to?(:to_io)
              env[:body][key] = Faraday::UploadIO.new(value, mime_type(value.path), value.path)
              env[:request_headers][CONTENT_TYPE] = self.class.mime_type
            elsif value.is_a?(Hash) && (value[:io].is_a?(IO) || value[:io].is_a?(StringIO))
              env[:body][key] = Faraday::UploadIO.new(value[:io], mime_type('.' + value[:type]), '')
              env[:request_headers][CONTENT_TYPE] = self.class.mime_type
            end
          end
        end
        @app.call(env)
      end

    private

      def mime_type(path)
        case path
        when /\.jpe?g/i
          'image/jpeg'
        when /\.gif$/i
          'image/gif'
        when /\.png$/i
          'image/png'
        else
          'application/octet-stream'
        end
      end

    end
  end
end
