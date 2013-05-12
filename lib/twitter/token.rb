require 'twitter/base'

module Twitter
  class Token < Twitter::Base
    attr_reader :token_type, :access_token
  end
end
