module Twitter
  class Client
    module Trends
      def trends(options={})
        get('trends', options)
      end

      def current_trends(options={})
        get('trends/current', options)
      end

      def daily_trends(date=Time.now, options={})
        get('trends/daily', options.merge(:date => date.strftime('%Y-%m-%d')))
      end

      def weekly_trends(date=Time.now, options={})
        get('trends/daily', options.merge(:date => date.strftime('%Y-%m-%d')))
      end
    end
  end
end
