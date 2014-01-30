require 'faraday'
require 'twitter/error'

module Twitter
  module REST
    module Response
      class RaiseError < Faraday::Response::Middleware
        def on_complete(env)
          status_code = env[:status].to_i
          error_class = Twitter::Error.errors[status_code]
          fail error_class.from_response(env) if error_class
        end
      end
    end
  end
end

Faraday::Response.register_middleware :raise_error => Twitter::REST::Response::RaiseError
