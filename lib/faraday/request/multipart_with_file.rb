require 'faraday'

# @private
module Faraday
  # @private
  class Request::MultipartWithFile < Faraday::Middleware
    def call(env)
      if env[:body].is_a?(Hash)
        env[:body].each do |key, value|
          if value.is_a?(File)
            env[:body][key] = Faraday::UploadIO.new(value, mime_type(value.path), value.path)
          elsif value.is_a?(Hash) && (value['io'].is_a?(IO) || value['io'].is_a?(StringIO))
            env[:body][key] = Faraday::UploadIO.new(value['io'], mime_type('.'+value['type']), '')
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
