require 'faraday_middleware'
require 'faraday/request/phoenix'
require 'faraday/request/multipart_with_file'
require 'faraday/request/gateway'
require 'faraday/request/twitter_oauth'
require 'faraday/response/raise_http_4xx'
require 'faraday/response/raise_http_5xx'

module Twitter
  # @private
  module Connection
    private

    def connection(options={})
      merged_options = faraday_options.merge({
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, api_endpoint),
      })

      Faraday.new(merged_options) do |builder|
        builder.use Faraday::Request::Phoenix if options[:phoenix]
        builder.use Faraday::Request::MultipartWithFile
        builder.use Faraday::Request::TwitterOAuth, authentication if authenticated?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Faraday::Request::Gateway, gateway if gateway
        builder.use Faraday::Response::RaiseHttp4xx
        unless options[:raw]
          builder.use Faraday::Response::Mashify
          builder.use Faraday::Response::ParseJson
        end
        builder.use Faraday::Response::RaiseHttp5xx
        builder.adapter(adapter)
      end
    end
  end
end
