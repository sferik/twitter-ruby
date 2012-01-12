require 'twitter/base'

module Twitter
  class OEmbed < Twitter::Base
    lazy_attr_reader :author_name,:author_url, :cache_age, :height, :html, :id,
      :provider_name, :provider_url, :type, :width, :url, :version
  end
end
