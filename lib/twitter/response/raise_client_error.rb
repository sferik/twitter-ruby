require 'faraday'
require 'twitter/error/bad_request'
require 'twitter/error/forbidden'
require 'twitter/error/not_acceptable'
require 'twitter/error/not_found'
require 'twitter/error/unauthorized'

module Twitter
  module Response
    class RaiseClientError < Faraday::Response::Middleware

      def on_complete(env)
        status_code = env[:status].to_i
        error_class = Twitter::Error::ClientError.errors[status_code]
        raise error_class.from_response_body(env[:body]) if error_class
      end

    end
  end
end
