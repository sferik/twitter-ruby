require 'twitter/card'

module Twitter
  class Card
    class ImageAppDownload < Twitter::Card
      # @return [String]
      attr_reader :app_country_code, :googleplay_app_id, :ipad_app_id, :iphone_app_id

      # @return [String]
      attr_reader :wide_app_image

      # @return [String]
      attr_reader :googleplay_deep_link, :ipad_deep_link, :iphone_deep_link
    end
  end
end
