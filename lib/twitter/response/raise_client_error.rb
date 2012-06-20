require 'faraday'
require 'twitter/error/bad_request'
require 'twitter/error/forbidden'
require 'twitter/error/not_acceptable'
require 'twitter/error/not_found'
require 'twitter/error/unauthorized'

module Twitter
  module Response
    class RaiseClientError < Faraday::Response::Middleware

      CLIENT_ERRORS = {
        400 => Twitter::Error::BadRequest,
        401 => Twitter::Error::Unauthorized,
        403 => Twitter::Error::Forbidden,
        404 => Twitter::Error::NotFound,
        406 => Twitter::Error::NotAcceptable,
      }

      def on_complete(env)
        if CLIENT_ERRORS.keys.include?(env[:status].to_i)
          raise CLIENT_ERRORS[env[:status].to_i].new(error_body(env[:body]), env[:response_headers])
        end
      end

    private

      def error_body(body)
        if body.nil?
          ''
        elsif body['error']
          body['error']
        elsif body['errors']
          first = Array(body['errors']).first
          if first.kind_of?(Hash)
            first['message'].chomp
          else
            first.chomp
          end
        end
      end

    end
  end
end
