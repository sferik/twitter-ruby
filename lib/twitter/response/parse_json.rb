require 'faraday'
require 'multi_json'

module Twitter
  module Response
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        case body
        when ''
          nil
        when 'true'
          true
        when 'false'
          false
        else
          MultiJson.load(body, :symbolize_keys => true)
        end
      end

      def on_complete(env)
        if respond_to?(:parse)
          env[:body] = parse(env[:body]) unless [204, 304].include?(env[:status])
        end
      end

    end
  end
end
