require 'twitter/base'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
                :language, :protected, :screen_name, :show_all_inline_media,
                :sleep_time, :time_zone
    object_attr_reader :Place, :trend_location
  end

  def always_use_https
   @attrs.always_use_https
end
def discoverable_by_email
   @attrs.discoverable_by_email
end
def geo_enabled
   @attrs.geo_enabled
end
def language
   @attrs.language
end
def protected
   @attrs.protected
end
def screen_name
   @attrs.screen_name
end
def show_all_inline_media
   @attrs.show_all_inline_media
end
def sleep_time
   @attrs.sleep_time
end
def time_zone
   @attrs.time_zone
end

end
