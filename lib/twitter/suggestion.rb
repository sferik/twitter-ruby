require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    attr_reader :name, :size, :slug

    # @param other [Twitter::Suggestion]
    # @return [Boolean]
    def ==(other)
      super || self.attr_equal(:slug, other) || self.attrs_equal(other)
    end

    # @return [Array<Twitter::User>]
    def users
      @users ||= Array(@attrs[:users]).map do |user|
        Twitter::User.fetch_or_store(user)
      end unless @attrs[:users].nil?
    end

  end
end
