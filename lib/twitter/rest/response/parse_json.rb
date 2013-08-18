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
            env[:body] = parse(env[:body]) unless [204, 301, 302, 304].include?(env[:status])
          end
        end

      end
    end
  end
end
