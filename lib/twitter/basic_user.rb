require 'twitter/identity'

module Twitter
  class BasicUser < Twitter::Identity
    attr_reader :following, :screen_name
    alias_method :handle, :screen_name
    alias_method :username, :screen_name
    alias_method :user_name, :screen_name
  end

  def following
  	@attrs.following
  end

  def screen_name
  	@attrs.screen_name
  end
  
end
