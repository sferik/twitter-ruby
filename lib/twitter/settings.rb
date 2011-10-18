require 'twitter/base'
require 'twitter/place'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone, :trend_location
    alias :protected? :protected

    def initialize(settings={})
      @trend_location = Twitter::Place.new(settings.delete('trend_location').first) unless settings['trend_location'].nil? || settings['trend_location'].empty?
      super(settings)
    end

  end
end
