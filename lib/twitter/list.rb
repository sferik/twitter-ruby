require 'twitter/base'
require 'twitter/user'

module Twitter
  class List < Twitter::Base
    lazy_attr_reader :description, :following, :full_name, :id, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias :following? :following

    # @param other [Twiter::List]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.new(@attrs['user']) unless @attrs['user'].nil?
    end

  end
end
