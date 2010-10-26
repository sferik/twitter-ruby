module Twitter
  class Client
    module LocalTrends
      def trend_locations(options={})
        response = get('trends/available', options)
        format.to_s.downcase == 'xml' ? response['locations'] : response
      end

      def local_trends(woeid=1, options={})
        response = get("trends/#{woeid}", options)
        format.to_s.downcase == 'xml' ? response['matching_trends'].first.trend : response.first.trends.map{|trend| trend.name}
      end
    end
  end
end
