require 'faraday'
require 'json'

module Twitter
  module REST
    module Response
      class ParseJson < Faraday::Response::Middleware
        WHITESPACE_REGEX = /\A^\s*$\z/

        def parse(body)
          case body
          when WHITESPACE_REGEX, nil
            nil
          else
            JSON.parse(body, :symbolize_names => true)
          end
        end

        def on_complete(response)
          if response.response_headers['content-encoding'] && response.response_headers['content-encoding'].include?("gzip")
            body = StringIO.new(response.body)
            string = Zlib::GzipReader.new(body).read
            response.body = string
          end
          response.body = parse(response.body) unless [204, 301, 302, 304].include?(response.status)
        end

        def unparsable_status_codes
          [204, 301, 302, 304]
        end
      end
    end
  end
end

Faraday::Response.register_middleware :parse_json => Twitter::REST::Response::ParseJson
