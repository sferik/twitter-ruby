require 'twitter/base'

module Twitter
  class Settings < Twitter::Base
    attr_reader :language, :screen_name, :sleep_time, :time_zone
    object_attr_reader :Place, :trend_location
    predicate_attr_reader :always_use_https, :discoverable_by_email,
                          :geo_enabled, :protected, :show_all_inline_media,
                          :use_cookie_personalization
  end
end
