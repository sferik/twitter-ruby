require 'twitter/basic_user'

module Twitter
  class TargetUser < Twitter::BasicUser
    attr_reader :followed_by
  end

  def attributes
        @attrs
    end

    def attr
        @attrs
    end

    
end
