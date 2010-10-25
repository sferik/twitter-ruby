module Twitter
  class Client
    module Tweets
      def status(id, options={})
        response = get("statuses/show/#{id}", options)
        format.to_s.downcase == 'xml' ? response.status : response
      end

      def update(status, options={})
        response = post('statuses/update', options.merge(:status => status))
        format.to_s.downcase == 'xml' ? response.status : response
      end

      def status_destroy(id, options={})
        response = delete("statuses/destroy/#{id}", options)
        format.to_s.downcase == 'xml' ? response.status : response
      end

      def retweet(id, options={})
        response = post("statuses/retweet/#{id}", options)
        format.to_s.downcase == 'xml' ? response.status : response
      end

      def retweets(id, options={})
        response = get("statuses/retweets/#{id}", options)
        format.to_s.downcase == 'xml' ? response.statuses : response
      end

      def retweeters_of(id, options={})
        ids_only = !!options.delete(:ids_only)
        response = get("statuses/#{id}/retweeted_by#{'/ids' if ids_only}", options)
        format.to_s.downcase == 'xml' ? response.users : response
      end
    end
  end
end
