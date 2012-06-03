require 'twitter/identifiable'

module Twitter
  class OEmbed < Twitter::Identifiable
    lazy_attr_reader :author_name,:author_url, :cache_age, :height, :html,
      :provider_name, :provider_url, :type, :width, :url, :version
  end
end
