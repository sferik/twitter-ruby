require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class List < Twitter::Identity
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri

    # @return [Twitter::User, Twitter::NullObject]
    def user
      new_or_null_object(Twitter::User, :user)
    end

    # @return [Boolean]
    def user?
      !user.nil?
    end

  end
end
