require 'twitter/card'

module Twitter
  class Card
    class Website < Twitter::Card
      # @return [String]
      attr_reader :website_cta, :website_title

      # @return [String]
      attr_reader :image, :website_dest_url, :website_display_url, :website_url
    end
  end
end
