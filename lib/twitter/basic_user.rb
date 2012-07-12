require 'twitter/identity'

module Twitter
  class BasicUser < Twitter::Identity
    attr_reader :following, :screen_name
    alias following? following
  end
end
