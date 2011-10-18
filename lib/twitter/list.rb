require 'twitter/base'
require 'twitter/user'

module Twitter
  class List < Twitter::Base
    attr_reader :user
    lazy_attr_reader :description, :following, :full_name, :id, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias :following? :following

    def initialize(attributes={})
      attributes = attributes.dup
      @user = Twitter::User.new(attributes.delete('user')) unless attributes['user'].nil?
      super(attributes)
    end

    def ==(other)
      super || (other.class == self.class && other.id == self.id)
    end

  end
end
