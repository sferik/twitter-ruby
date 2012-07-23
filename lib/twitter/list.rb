require 'twitter/creatable'
require 'twitter/identity'
require 'twitter/user'

module Twitter
  class List < Twitter::Identity
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri
    alias following? following

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.fetch_or_new(@attrs[:user])
    end

  end
end
