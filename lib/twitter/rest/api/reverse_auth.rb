require 'twitter/rest/api/utils'
require 'twitter/token'

module Twitter
  module REST
    module API
      module ReverseAuth
        include Twitter::REST::API::Utils

        def reverse_token
          conn = connection.dup
          conn.builder.delete Twitter::REST::Response::ParseJson
          conn.post('/oauth/request_token?x_auth_mode=reverse_auth') do |request|
            request.headers[:authorization] = oauth_auth_header(:post, 'https://api.twitter.com/oauth/request_token', x_auth_mode: 'reverse_auth').to_s
          end.body
        end
      end
    end
  end
end
