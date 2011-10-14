require 'twitter/base'
require 'twitter/place'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone, :trend_location
    alias :protected? :protected

    def initialize(settings={})
      @always_use_https = settings['always_use_https']
      @discoverable_by_email = settings['discoverable_by_email']
      @geo_enabled = settings['geo_enabled']
      @language = settings['language']
      @protected = settings['protected']
      @screen_name = settings['screen_name']
      @show_all_inline_media = settings['show_all_inline_media']
      @sleep_time = settings['sleep_time']
      @time_zone = settings['time_zone']
      @trend_location = Twitter::Place.new(settings['trend_location'].first) unless settings['trend_location'].nil? || settings['trend_location'].empty?
    end

  end
end
