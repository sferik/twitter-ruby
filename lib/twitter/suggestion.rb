require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    lazy_attr_reader :name, :size, :slug

    def ==(other)
      super || (other.class == self.class && other.slug == self.slug)
    end

    def users
      @users = Array(@attributes['users']).map do |user|
        Twitter::User.new(user)
      end
    end

  end
end
