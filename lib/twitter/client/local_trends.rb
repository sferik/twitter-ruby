module Twitter
  class Client
    module LocalTrends
      def trend_locations(options={})
        get('trends/available', options)
      end

      def local_trends(woeid=1, options={})
        get("trends/#{woeid}", options)
      end
    end
  end
end
