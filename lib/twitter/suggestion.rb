require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    attr_reader :users
    lazy_attr_reader :name, :size, :slug

    def initialize(attributes={})
      attributes = attributes.dup
      @users = attributes.delete('users').map do |user|
        Twitter::User.new(user)
      end unless attributes['users'].nil?
      super(attributes)
    end

    def ==(other)
      super || (other.class == self.class && other.slug == self.slug)
    end

  end
end
