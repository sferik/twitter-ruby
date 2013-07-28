require 'twitter/base'

module Twitter
  class Settings < Twitter::Base
    attr_reader :always_use_https, :discoverable_by_email, :geo_enabled,
      :language, :protected, :screen_name, :show_all_inline_media, :sleep_time,
      :time_zone

    # @return [Twitter::Place, Twitter::NullObject]
    def trend_location
      new_or_null_object(Twitter::Place, :trend_location)
    end

    # @return [Boolean]
    def trend_location?
      !trend_location.nil?
    end

  end
end
