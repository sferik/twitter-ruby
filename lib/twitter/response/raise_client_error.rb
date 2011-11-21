require 'faraday'
require 'twitter/error/bad_request'
require 'twitter/error/enhance_your_calm'
require 'twitter/error/forbidden'
require 'twitter/error/not_acceptable'
require 'twitter/error/not_found'
require 'twitter/error/unauthorized'

module Twitter
  module Response
    class RaiseClientError < Faraday::Response::Middleware

      def on_complete(env)
        case env[:status].to_i
        when 400
          raise Twitter::Error::BadRequest.new(error_body(env[:body]), env[:response_headers])
        when 401
          raise Twitter::Error::Unauthorized.new(error_body(env[:body]), env[:response_headers])
        when 403
          raise Twitter::Error::Forbidden.new(error_body(env[:body]), env[:response_headers])
        when 404
          raise Twitter::Error::NotFound.new(error_body(env[:body]), env[:response_headers])
        when 406
          raise Twitter::Error::NotAcceptable.new(error_body(env[:body]), env[:response_headers])
        when 420
          raise Twitter::Error::EnhanceYourCalm.new(error_body(env[:body]), env[:response_headers])
        end
      end

    private

      def error_body(body)
        if body.nil?
          nil
        elsif body['error']
          ": #{body['error']}"
        elsif body['errors']
          first = Array(body['errors']).first
          if first.kind_of? Hash
            ": #{first['message'].chomp}"
          else
            ": #{first.chomp}"
          end
        end
      end

    end
  end
end
