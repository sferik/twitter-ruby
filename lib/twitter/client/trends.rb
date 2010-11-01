module Twitter
  class Client
    module Trends
      # Returns the top ten topics that are currently trending on Twitter. The response includes the time of the request,
      # the name of each trend, and the url to the {http://search.twitter.com Twitter Search} results page for that topic.
      #
      # @formats :json
      # @authenticated false
      # @rate_limited true
      # @param options [Hash] A customizable set of options.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends
      def trends(options={})
        get('trends', options)['trends']
      end

      # Returns the current top 10 trending topics on Twitter. The response includes the time of the request,
      # the name of each trending topic, and query used on {http://search.twitter.com Twitter Search} results page for that topic.
      #
      # @formats :json
      # @authenticated false
      # @rate_limited true
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends/current
      def trends_current(options={})
        get('trends/current', options)['trends']
      end

      # Returns the top 20 trending topics for each hour in a given day.
      #
      # @formats :json
      # @authenticated false
      # @rate_limited true
      # @param date [String] The start date for the report. The date should be formatted YYYY-MM-DD. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends/daily
      def trends_daily(date=Time.now, options={})
        get('trends/daily', options.merge(:date => date.strftime('%Y-%m-%d')))['trends']
      end

      # Returns the top 30 trending topics for each day in a given week.
      #
      # @formats :json
      # @authenticated false
      # @rate_limited true
      # @param date [String] The start date for the report. The date should be formatted YYYY-MM-DD. A 404 error will be thrown if the date is older than the available search index (7-10 days). Dates in the future will be forced to the current date.
      # @param options [Hash] A customizable set of options.
      # @option options [String] :exclude Setting this equal to 'hashtags' will remove all hashtags from the trends list.
      # @return [Array]
      # @see http://dev.twitter.com/doc/get/trends/weekly
      def trends_weekly(date=Time.now, options={})
        get('trends/weekly', options.merge(:date => date.strftime('%Y-%m-%d')))['trends']
      end
    end
  end
end
