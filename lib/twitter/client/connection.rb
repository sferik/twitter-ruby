require 'faraday'
require 'faraday_middleware'

require 'faraday/multipart'
require 'faraday/oauth'
require 'faraday/raise_http_4xx'
require 'faraday/raise_http_5xx'

module Twitter
  class Client
    module Connection
      private

        def connection(raw=false)
          options = {
            :headers => {:user_agent => user_agent},
            :ssl => {:verify => false},
            :url => endpoint
          }

          Faraday::Connection.new(options) do |builder|
            builder.use Faraday::Request::Multipart
            builder.use Faraday::Request::OAuth, authentication if authenticate?
            builder.adapter(adapter)
            builder.use Faraday::Response::RaiseHttp5xx
            builder.use Faraday::Response::Parse unless raw
            builder.use Faraday::Response::RaiseHttp4xx
            builder.use Faraday::Response::Mashify unless raw
          end
        end
    end
  end
end
