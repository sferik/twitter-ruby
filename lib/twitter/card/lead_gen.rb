require 'twitter/card'

module Twitter
  class Card
    class LeadGen < Twitter::Card
      # @return [String]
      attr_reader :cta, :custom_destination_text, :custom_key_email,
        :custom_key_name, :custom_key_screen_name, :submit_method, :title

      # @return [String]
      attr_reader :custom_destination_url, :fallback_url, :image,
        :privacy_policy_url, :submit_url

      def custom_params
        attrs.select { |k,v| k.to_s.start_with?('custom_param_') }.reduce({}) do |hash, pair|
          key = pair[0].to_s.sub('custom_param_', '').to_sym
          hash[key] = pair[1]
          hash
        end
      end
      memoize :custom_params
    end
  end
end
