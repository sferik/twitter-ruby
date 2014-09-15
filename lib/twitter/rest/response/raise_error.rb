require 'faraday'
require 'twitter/error'

module Twitter
  module REST
    module Response
      class RaiseError < Faraday::Response::Middleware
        def on_complete(response)
          status_code = response.status.to_i
          klass = Twitter::Error.errors[status_code]
          return unless klass
          if klass == Twitter::Error::Forbidden
            fail(handle_forbidden_errors(response))
          else
            fail(klass.from_response(response))
          end
        end

      private

        def handle_forbidden_errors(response)
          error = Twitter::Error::Forbidden.from_response(response)
          klass = Twitter::Error.forbidden_messages[error.message]
          if klass
            klass.from_response(response)
          else
            error
          end
        end
      end
    end
  end
end

Faraday::Response.register_middleware :twitter_raise_error => Twitter::REST::Response::RaiseError
