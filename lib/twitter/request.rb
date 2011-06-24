module Twitter
  # Defines HTTP request methods
  module Request
    # Perform an HTTP GET request
    def get(path, options={}, format=format)
      request(:get, path, options, format)
    end

    # Perform an HTTP POST request
    def post(path, options={}, format=format)
      request(:post, path, options, format)
    end

    # Perform an HTTP PUT request
    def put(path, options={}, format=format)
      request(:put, path, options, format)
    end

    # Perform an HTTP DELETE request
    def delete(path, options={}, format=format)
      request(:delete, path, options, format)
    end

    private

    # Perform an HTTP request
    def request(method, path, options, format)
      response = connection(format).send(method) do |request|
        case method.to_sym
        when :get, :delete
          request.url(formatted_path(path, format), options)
        when :post, :put
          request.path = formatted_path(path, format)
          request.body = options unless options.empty?
        end
      end
      'raw' == format.to_s.downcase ? response : response.body
    end

    def formatted_path(path, format)
      case format.to_s.downcase
      when 'json', 'xml'
        [path, format].compact.join('.')
      when 'raw'
        [path, Twitter.format].compact.join('.')
      end
    end
  end
end
