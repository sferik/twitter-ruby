require 'faraday'
require 'twitter/request/gateway'
require 'twitter/request/multipart_with_file'
require 'twitter/request/phoenix'
require 'twitter/request/oauth'
require 'twitter/response/parse_json'
require 'twitter/response/raise_client_error'
require 'twitter/response/raise_server_error'

module Twitter
  module Connection
  private

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection(options={})
      merged_options = connection_options.merge({
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => options.fetch(:endpoint, api_endpoint),
      })
      Faraday.new(merged_options) do |builder|
        builder.use Twitter::Request::Phoenix if options[:phoenix]
        builder.use Twitter::Request::MultipartWithFile
        builder.use Twitter::Request::TwitterOAuth, credentials if credentials?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Twitter::Request::Gateway, gateway if gateway
        builder.use Twitter::Response::RaiseClientError
        builder.use Twitter::Response::ParseJson unless options[:raw]
        builder.use Twitter::Response::RaiseServerError
        builder.adapter(adapter)
      end
    end

  end
end
