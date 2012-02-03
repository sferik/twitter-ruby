require 'faraday'

module Twitter
  module Request
    class Phoenix < Faraday::Middleware

      def call(env)
        # Not sure what what the X-Phx (Phoenix?) header is for but it's
        # required to access certain undocumented resources
        # e.g. GET urls/resolve
        env[:request_headers]['X-Phx'] = 'true' if env[:request][:phoenix]

        @app.call(env)
      end

      def initialize(app)
        @app = app
      end

    end
  end
end
