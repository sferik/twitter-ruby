require 'twitter/base'
require 'twitter/place'

module Twitter
  class Settings < Twitter::Base
    lazy_attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone
    alias :protected? :protected

    def trend_location
      @trend_location ||= Twitter::Place.new(@attributes['trend_location'].first) unless @attributes['trend_location'].nil? || @attributes['trend_location'].empty?
    end

  end
end
