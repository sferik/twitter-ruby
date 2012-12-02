require 'twitter/base'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone

    # @return [Twitter::Place]
    def trend_location
      @trend_location ||= Twitter::Place.fetch_or_new(Array(@attrs[:trend_location]).first)
    end

  end
end
