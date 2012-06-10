require 'faraday'
require 'twitter/core_ext/hash'
require 'twitter/request/multipart_with_file'
require 'twitter/request/oauth'
require 'twitter/response/parse_json'
require 'twitter/response/raise_client_error'
require 'twitter/response/raise_server_error'
require 'uri'

module Twitter
  # Defines HTTP request methods
  module Requestable

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    # Perform an HTTP POST request
    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

  private

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      return @connection if defined? @connection

      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => user_agent,
        },
        :proxy => proxy,
        :ssl => {:verify => false},
        :url => endpoint,
      }

      @connection = Faraday.new(default_options.deep_merge(connection_options)) do |builder|
        builder.use Twitter::Request::MultipartWithFile
        builder.use Twitter::Request::OAuth, credentials if credentials?
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Twitter::Response::RaiseClientError
        builder.use Twitter::Response::ParseJson
        builder.use Twitter::Response::RaiseServerError
        builder.adapter adapter
      end
    end

    # Perform an HTTP request
    def request(method, path, params, options)
      if url = options[:endpoint]
        url = URI(url) unless url.respond_to? :host
        path = url + path
      end
      response = connection.run_request(method.to_sym, path, nil, nil) do |request|
        request.options[:raw] = true if options[:raw]
        unless params.empty?
          if :post == request.method
            request.body = params
          else
            request.params.update params
          end
        end
        yield request if block_given?
      end
      options[:raw] ? response : response.body
    rescue Faraday::Error::ClientError
      raise Twitter::Error::ClientError
    end

  end
end
