require 'faraday_middleware'
require 'faraday/request/multipart_with_file'
require 'faraday/request/gateway'
require 'faraday/request/twitter_oauth'
require 'faraday/response/raise_http_4xx'
require 'faraday/response/raise_http_5xx'

module Twitter
  # @private
  module Connection
    private

    def connection(format=format)
      options = {
        :headers => {
          'Accept' => "application/#{format}",
          'User-Agent' => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => api_endpoint,
      }

      Faraday.new(options) do |builder|
        builder.use Faraday::Request::MultipartWithFile
        builder.use Faraday::Request::TwitterOAuth, authentication if authenticated?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Request::Gateway, gateway if gateway
        builder.use Faraday::Response::RaiseHttp4xx
        case format.to_s.downcase
        when 'json'
          builder.use Faraday::Response::Mashify
          builder.use Faraday::Response::ParseJson
        when 'xml'
          builder.use Faraday::Response::Mashify
          builder.use Faraday::Response::ParseXml
        end
        builder.use Faraday::Response::RaiseHttp5xx
        builder.adapter(adapter)
      end
    end
  end
end
