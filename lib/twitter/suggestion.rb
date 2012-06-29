require 'twitter/base'
require 'twitter/user'

module Twitter
  class Suggestion < Twitter::Base
    attr_reader :name, :size, :slug

    # @param other [Twitter::Suggestion]
    # @return [Boolean]
    def ==(other)
      super || self.slug_equal(other) || self.attrs_equal(other)
    end

    # @return [Array<Twitter::User>]
    def users
      @users ||= Array(@attrs[:users]).map do |user|
        Twitter::User.fetch_or_new(user)
      end unless @attrs[:users].nil?
    end

  protected

    # @param other [Twitter::Suggestion]
    # @return [Boolean]
    def slug_equal(other)
      self.class == other.class && !other.slug.nil? && self.slug == other.slug
    end

  end
end
