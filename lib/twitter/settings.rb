require 'twitter/base'
require 'twitter/place'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone
    alias protected? protected

    # @return [Twitter::Place]
    def trend_location
      @trend_location ||= Twitter::Place.fetch_or_new(@attrs[:trend_location].first) unless @attrs[:trend_location].nil? || @attrs[:trend_location].empty?
    end

  end
end
