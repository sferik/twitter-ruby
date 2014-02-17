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
    object_attr_reader :Tweet, :status, :user
    {
      :favorites_count => :favourites_count,
      :profile_background_image_uri => :profile_background_image_url,
      :profile_background_image_uri_https => :profile_background_image_url_https,
      :translator? => :is_translator,
      :tweets_count => :statuses_count,
      :tweet => :status,
      :tweet? => :status?,
      :tweeted? => :status?,
    }.each do |new_method, existing_method|
      alias_method new_method, existing_method
    end
    remove_method :favourites_count

    # @return [Array<Twitter::Entity::URI>]
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
