require "twitter/creatable"
require "twitter/identity"

module Twitter
  # Represents a Twitter list
  class List < Identity
    include Creatable

    # The number of members in this list
    #
    # @api public
    # @example
    #   list.member_count
    # @return [Integer]

    # The number of subscribers to this list
    #
    # @api public
    # @example
    #   list.subscriber_count
    # @return [Integer]
    attr_reader :member_count, :subscriber_count

    # The description of this list
    #
    # @api public
    # @example
    #   list.description
    # @return [String]

    # The full name of this list
    #
    # @api public
    # @example
    #   list.full_name
    # @return [String]

    # The mode of this list (public or private)
    #
    # @api public
    # @example
    #   list.mode
    # @return [String]

    # The name of this list
    #
    # @api public
    # @example
    #   list.name
    # @return [String]

    # The slug of this list
    #
    # @api public
    # @example
    #   list.slug
    # @return [String]
    attr_reader :description, :full_name, :mode, :name, :slug

    object_attr_reader :User, :user
    predicate_attr_reader :following

    # Returns the URI to the list members
    #
    # @api public
    # @example
    #   list.members_uri
    # @return [Addressable::URI]
    def members_uri
      Addressable::URI.parse("#{uri}/members") if uri?
    end
    memoize :members_uri

    # @!method members_url
    #   Returns the URL to the list members
    #   @api public
    #   @example
    #     list.members_url
    #   @return [Addressable::URI]
    alias_method :members_url, :members_uri

    # Returns the URI to the list subscribers
    #
    # @api public
    # @example
    #   list.subscribers_uri
    # @return [Addressable::URI]
    def subscribers_uri
      Addressable::URI.parse("#{uri}/subscribers") if uri?
    end
    memoize :subscribers_uri

    # @!method subscribers_url
    #   Returns the URL to the list subscribers
    #   @api public
    #   @example
    #     list.subscribers_url
    #   @return [Addressable::URI]
    alias_method :subscribers_url, :subscribers_uri

    # Returns the URI to the list
    #
    # @api public
    # @example
    #   list.uri
    # @return [Addressable::URI]
    def uri
      Addressable::URI.parse("https://twitter.com/#{user.screen_name}/#{slug}") if slug? && user.screen_name?
    end
    memoize :uri

    # @!method url
    #   Returns the URL to the list
    #   @api public
    #   @example
    #     list.url
    #   @return [Addressable::URI]
    alias_method :url, :uri

    # Returns true if a URI is available for this list
    #
    # @api public
    # @example
    #   list.uri?
    # @return [Boolean]
    def uri?
      !!uri
    end
    memoize :uri?
  end
end
