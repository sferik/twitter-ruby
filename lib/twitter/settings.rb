require 'twitter/base'
require 'twitter/place'

module Twitter
  class Settings < Twitter::Base
    attr_reader :trend_location
    lazy_attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone
    alias :protected? :protected

    def initialize(attributes={})
      attributes = attributes.dup
      @trend_location = Twitter::Place.new(attributes.delete('trend_location').first) unless attributes['trend_location'].nil? || attributes['trend_location'].empty?
      super(attributes)
    end

  end
end
