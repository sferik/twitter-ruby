require 'twitter/base'

module Twitter
  class OEmbed < Twitter::Base
    attr_reader :author_name, :cache_age, :height, :html, :provider_name,
      :type, :version, :width

    # @return [URI]
    def author_uri
      @author_uri ||= ::URI.parse(@attrs[:author_url]) if author_uri?
    end
    alias author_url author_uri

    # @return [Boolean]
    def author_uri?
      !!@attrs[:author_url]
    end

    # @return [URI]
    def provider_uri
      @provider_uri ||= ::URI.parse(@attrs[:provider_url]) if provider_uri?
    end
    alias provider_url provider_uri

    # @return [Boolean]
    def provider_uri?
      !!@attrs[:provider_url]
    end

    # @return [URI] The URI to the tweet.
    def uri
      @uri ||= ::URI.parse(@attrs[:url]) if uri?
    end
    alias url uri

    # @return [Boolean]
    def uri?
      !!@attrs[:url]
    end
    alias url? uri?

  end
end
