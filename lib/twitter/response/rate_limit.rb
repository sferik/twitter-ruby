require 'faraday'
require 'twitter/rate_limit'

module Twitter
  module Response
    class RateLimit < Faraday::Response::Middleware

      def on_complete(env)
        Twitter::RateLimit.instance.update(env[:response_headers])
      end

    end
  end
end
