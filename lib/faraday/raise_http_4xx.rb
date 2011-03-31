require 'faraday'

# @private
module Faraday
  # @private
  class Response::RaiseHttp4xx < Response::Middleware
    def self.register_on_complete(env)
      env[:response].on_complete do |response|
        case response[:status].to_i
        when 400
          raise Twitter::BadRequest.new(error_message(response), response[:response_headers])
        when 401
          raise Twitter::Unauthorized.new(error_message(response), response[:response_headers])
        when 403
          raise Twitter::Forbidden.new(error_message(response), response[:response_headers])
        when 404
          raise Twitter::NotFound.new(error_message(response), response[:response_headers])
        when 406
          raise Twitter::NotAcceptable.new(error_message(response), response[:response_headers])
        when 420
          raise Twitter::EnhanceYourCalm.new(error_message(response), response[:response_headers])
        end
      end
    end

    def initialize(app)
      super
      @parser = nil
    end

    private

    def self.error_message(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]}#{error_body(response[:body])}"
    end

    def self.error_body(body)
      if body.nil?
        nil
      elsif body['error']
        ": #{body['error']}"
      elsif body['errors']
        first = body['errors'].to_a.first
        if first.kind_of? Hash
          ": #{first['message'].chomp}"
        else
          ": #{first.chomp}"
        end
      end
    end
  end
end
