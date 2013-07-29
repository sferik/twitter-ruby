require 'twitter/base'

module Twitter
  class OEmbed < Twitter::Base
    attr_reader :author_name, :cache_age, :height, :html, :provider_name,
      :type, :version, :width
    uri_attr_reader :author_uri, :provider_uri, :uri
  end
end
