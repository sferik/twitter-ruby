require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class List < Twitter::Identity
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
      :mode, :name, :slug, :subscriber_count
    object_attr_reader :User, :user

    # @return [URI] The URI to the list members.
    def members_uri
      @members_uri ||= ::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}/members")
    end
    alias members_url members_uri

    # @return [URI] The URI to the list subscribers.
    def subscribers_uri
      @subscribers_uri ||= ::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}/subscribers")
    end
    alias subscribers_url subscribers_uri

    # @return [URI] The URI to the list.
    def uri
      @uri ||= ::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}")
    end
    alias url uri

  end
end
