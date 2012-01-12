require 'faraday'
require 'multi_json'

module Twitter
  module Response
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        unless (respond_to?(:env)) && env[:request][:raw]
          body = case body
                when ''
                  nil
                when 'true'
                  true
                when 'false'
                  false
                else
                  ::MultiJson.decode(body) 
                end 
        end
        body
      end

    end
  end
end
