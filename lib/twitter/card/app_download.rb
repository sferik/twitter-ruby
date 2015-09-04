require 'twitter/card'

module Twitter
  class Card
    class AppDownload < Twitter::Card
      # @return [String]
      attr_reader :app_country_code, :googleplay_app_id, :ipad_app_id, :iphone_app_id

      # @return [String]
      attr_reader :iphone_deep_link
    end
  end
end
