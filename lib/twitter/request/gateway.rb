require 'faraday'

module Twitter
  module Request
    class Gateway < Faraday::Middleware

      def call(env)
        url = env[:url].dup
        url.host = @gateway
        env[:url] = url
        @app.call(env)
      end

      def initialize(app, gateway)
        @app, @gateway = app, gateway
      end

    end
  end
end
