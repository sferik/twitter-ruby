require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    attr_reader :name, :size, :slug

    # @param other [Twitter::Suggestion]
    # @return [Boolean]
    def ==(other)
      super || (other.class == self.class && other.slug == self.slug)
    end

    # @return [Array<Twitter::User>]
    def users
      @users = Array(@attrs[:users]).map do |user|
        Twitter::User.fetch_or_new(user)
      end
    end

  end
end
