require 'faraday'
require 'json'

module Twitter
  module REST
    module Response
      class ParseJson < Faraday::Response::Middleware

        def parse(body)
          case body
          when /\A^\s*$\z/, nil
            nil
          else
            JSON.parse(body, :symbolize_names => true)
          end
        end

        def on_complete(env)
          if respond_to?(:parse)
            env[:body] = parse(env[:body]) unless unparsable_status_codes.include?(env[:status])
          end
        end

        def unparsable_status_codes
          [204, 301, 302, 304]
        end

      end
    end
  end
end
