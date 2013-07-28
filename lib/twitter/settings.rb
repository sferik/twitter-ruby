require 'twitter/base'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone
    object_attr_reader :Place, :trend_location
  end
end
