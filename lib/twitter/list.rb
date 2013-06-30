require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class List < Twitter::Identity
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count, :uri

    # @return [Twitter::User]
    def user
      @user ||= Twitter::User.new(@attrs[:user]) unless @attrs[:user].nil?
    end

  end
end
