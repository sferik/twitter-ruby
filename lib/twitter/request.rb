module Twitter
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, params={}, options={})
      request(:get, path, params, options)
    end

    def post(path, params={}, options={})
      request(:post, path, params, options)
    end

    # Perform an HTTP PUT request
    def put(path, params={}, options={})
      request(:put, path, params, options)
    end

    # Perform an HTTP DELETE request
    def delete(path, params={}, options={})
      request(:delete, path, params, options)
    end

    private

    # Perform an HTTP request
    def request(method, path, params, options)
      response = connection(options).send(method) do |request|
        case method.to_sym
        when :get, :delete
          request.url(formatted_path(path, options), params)
        when :post, :put
          request.path = formatted_path(path, options)
          request.body = params unless params.empty?
        end
      end
      options[:raw] ? response : response.body
    end

    def formatted_path(path, options={})
      [path, options.fetch(:format, format)].compact.join('.')
    end
  end
end
