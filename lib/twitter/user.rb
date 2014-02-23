require 'addressable/uri'
require 'memoizable'
require 'twitter/basic_user'
require 'twitter/creatable'
require 'twitter/entity/uri'
require 'twitter/profile'

module Twitter
  class User < Twitter::BasicUser
    include Twitter::Creatable
    include Twitter::Profile
    include Memoizable
    attr_reader :connections, :contributors_enabled, :default_profile,
                :default_profile_image, :description, :favourites_count,
                :follow_request_sent, :followers_count, :friends_count,
                :geo_enabled, :is_translator, :lang, :listed_count, :location,
                :name, :notifications, :profile_background_color,
                :profile_background_image_url,
                :profile_background_image_url_https, :profile_background_tile,
                :profile_link_color, :profile_sidebar_border_color,
                :profile_sidebar_fill_color, :profile_text_color,
                :profile_use_background_image, :protected, :statuses_count,
                :time_zone, :utc_offset, :verified
    alias_method :favorites_count, :favourites_count
    remove_method :favourites_count
    alias_method :profile_background_image_uri, :profile_background_image_url
    alias_method :profile_background_image_uri_https, :profile_background_image_url_https
    alias_method :translator?, :is_translator
    alias_method :tweets_count, :statuses_count
    object_attr_reader :Tweet, :status, :user
    alias_method :tweet, :status
    alias_method :tweet?, :status?
    alias_method :tweeted?, :status?

    # @return [Array<Twitter::Entity::URI>]
    def connections
   @attrs.connections
end
def contributors_enabled
   @attrs.contributors_enabled
end
def default_profile
   @attrs.default_profile
end
def default_profile_image
   @attrs.default_profile_image
end
def description
   @attrs.description
end
def favourites_count
   @attrs.favourites_count
end
def follow_request_sent
   @attrs.follow_request_sent
end
def followers_count
   @attrs.followers_count
end
def friends_count
   @attrs.friends_count
end
def geo_enabled
   @attrs.geo_enabled
end
def is_translator
   @attrs.is_translator
end
def lang
   @attrs.lang
end
def listed_count
   @attrs.listed_count
end
def location
   @attrs.location
end
def name
   @attrs.name
end
def notifications
   @attrs.notifications
end
def profile_background_color
   @attrs.profile_background_color
end
def profile_background_image_url
   @attrs.profile_background_image_url
end
def profile_background_image_url_https
   @attrs.profile_background_image_url_https
end
def profile_background_tile
   @attrs.profile_background_tile
end
def profile_link_color
   @attrs.profile_link_color
end
def profile_sidebar_border_color
   @attrs.profile_sidebar_border_color
end
def profile_sidebar_fill_color
   @attrs.profile_sidebar_fill_color
end
def profile_text_color
   @attrs.profile_text_color
end
def profile_use_background_image
   @attrs.profile_use_background_image
end
def protected
   @attrs.protected
end
def statuses_count
   @attrs.statuses_count
end
def time_zone
   @attrs.time_zone
end
def utc_offset
   @attrs.utc_offset
end
def verified
   @attrs.verified
end
    
    def description_uris
      Array(@attrs[:entities][:description][:urls]).collect do |entity|
        Entity::URI.new(entity)
      end
    end
    memoize :description_uris
    alias_method :description_urls, :description_uris

    # @return [String] The URL to the user.
    def uri
      Addressable::URI.parse("https://twitter.com/#{screen_name}") unless screen_name.nil?
    end
    memoize :uri
    alias_method :url, :uri

    # @return [String] The URL to the user's website.
    def website
      Addressable::URI.parse(@attrs[:url]) unless @attrs[:url].nil?
    end
    memoize :website

    def website?
      !!@attrs[:url]
    end
    memoize :website?
  end
end
