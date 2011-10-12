require 'twitter/base'
require 'twitter/user'

module Twitter
  class List < Twitter::Base
    attr_reader :description, :following, :full_name, :id, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias :following? :following

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def user
      Twitter::User.new(@user) if @user
    end
  end
end
