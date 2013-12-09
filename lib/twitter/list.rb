require 'twitter/creatable'
require 'twitter/identity'

module Twitter
  class List < Twitter::Identity
    include Twitter::Creatable
    attr_reader :description, :following, :full_name, :member_count,
                :mode, :name, :slug, :subscriber_count
    object_attr_reader :User, :user

    # @return [Addressable::URI] The URI to the list members.
    def members_uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}/members")
    end
    memoize :members_uri
    alias_method :members_url, :members_uri

    # @return [Addressable::URI] The URI to the list subscribers.
    def subscribers_uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}/subscribers")
    end
    memoize :subscribers_uri
    alias_method :subscribers_url, :subscribers_uri

    # @return [Addressable::URI] The URI to the list.
    def uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}")
    end
    memoize :uri
    alias_method :url, :uri
  end
end
