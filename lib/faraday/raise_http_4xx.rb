require 'faraday'

# @private
module Faraday
  # @private
  class Response::RaiseHttp4xx < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Twitter::BadRequest, error_message(response)
        when 401
          raise Twitter::Unauthorized, error_message(response)
        when 403
          raise Twitter::Forbidden, error_message(response)
        when 404
          raise Twitter::NotFound, error_message(response)
        when 406
          raise Twitter::NotAcceptable, error_message(response)
        when 420
          raise Twitter::EnhanceYourCalm.new error_message(response), response[:response_headers]
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end

    private

    def self.error_message(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:response_headers]['status']}#{error_body(response[:body])}"
    end

    def self.error_body(body)
      if body.nil?
        nil
      elsif body['error']
        ": #{body['error']}"
      elsif body['errors']
        ": #{body['errors'].to_a.first.chomp}"
      end
    end
  end
end
