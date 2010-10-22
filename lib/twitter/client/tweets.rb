module Twitter
  class Client
    module Tweets
      def status(id, options={})
        authenticate do
          get("statuses/show/#{id}", options)
        end
      end

      def update(status, options={})
        authenticate! do
          post('statuses/update', options.merge(:status => status))
        end
      end

      def status_destroy(id, options={})
        authenticate! do
          delete("statuses/destroy/#{id}", options)
        end
      end

      def retweet(id, options={})
        authenticate! do
          post("statuses/retweet/#{id}", options)
        end
      end

      def retweets(id, options={})
        get("statuses/retweets/#{id}", options)
      end

      def retweeters_of(id, options={})
        ids_only = !!options.delete(:ids_only)
        get("statuses/#{id}/retweeted_by#{'/ids' if ids_only}", options)
      end
    end
  end
end
