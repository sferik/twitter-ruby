module Twitter
  class RateLimitStatus
    include EasyClassMaker
    
    attributes :reset_time_in_seconds, :reset_time, :remaining_hits, :hourly_limit
    
    class << self
      # Creates a new rate limi status from a piece of xml
      def new_from_xml(xml)
        RateLimitStatus.new do |s|
          s.reset_time_in_seconds = xml.at('reset-time-in-seconds').inner_html.to_i
          s.reset_time            = Time.parse xml.at('reset-time').inner_html
          s.remaining_hits        = xml.at('remaining-hits').inner_html.to_i
          s.hourly_limit          = xml.at('hourly-limit').inner_html.to_i
        end
      end
    end
  end
end