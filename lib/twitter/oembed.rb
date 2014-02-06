require 'twitter/base'

module Twitter
  class OEmbed < Twitter::Base
    attr_reader :author_name, :cache_age, :height, :html, :provider_name,
                :type, :version, :width
    uri_attr_reader :author_uri, :provider_uri, :uri
  end

  def author_name
   @attrs.author_name
end
def cache_age
   @attrs.cache_age
end
def height
   @attrs.height
end
def html
   @attrs.html
end
def provider_name
   @attrs.provider_name
end
def type
   @attrs.type
end
def version
   @attrs.version
end
def width
   @attrs.width
end

end
