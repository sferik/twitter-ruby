require 'twitter/base'
require 'twitter/user'

module Twitter
  class List < Twitter::Base
    lazy_attr_reader :description, :following, :full_name, :id, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias :following? :following

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    def user
      @user ||= Twitter::User.new(@attributes['user']) unless @attributes['user'].nil?
    end

  end
end
