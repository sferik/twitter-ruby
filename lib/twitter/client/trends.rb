module Twitter
  class Client
    module Trends
      def trends(options={})
        get('trends', options)['trends']
      end

      def trends_current(options={})
        get('trends/current', options)['trends']
      end

      def trends_daily(date=Time.now, options={})
        get('trends/daily', options.merge(:date => date.strftime('%Y-%m-%d')))['trends']
      end

      def trends_weekly(date=Time.now, options={})
        get('trends/weekly', options.merge(:date => date.strftime('%Y-%m-%d')))['trends']
      end
    end
  end
end
