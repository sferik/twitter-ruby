module Twitter
  module Stream
    module Common

      def self.included(base)
      end

      attr_accessor :request

      def initialize(options)
        @callbacks = {}
        @options   = DEFAULT_OPTIONS.merge(options)
        @io        = Twitter::Stream::IO.new(@options[:host], @options[:port])
      end

      def on(event, &block)
        if block_given?
          @callbacks[event.to_s] = block
        else
          @callbacks[event.to_s]
        end
      end

      def on_scrub_geo(&block)
        on('scrub_geo', &block)
      end

      def on_delete(&block)
        on('delete', &block)
      end

      def on_limit(&block)
        on('limit', &block)
      end

      def on_reconnect(&block)
        on('reconnect', &block)
      end

      def on_disconnect(&block)
        on('disconnect', &block)
      end

      def on_status_withheld(&block)
        on('status_withheld', &block)
      end

      def on_user_withheld(&block)
        on('user_withheld', &block)
      end

      def on_stall_warning(&block)
        on('stall_warning', &block)
      end

      def on_no_data_received(&block)
        on('no_data_received', &block)
      end

      def on_error(&block)
        on('error', &block)
      end

      def on_unauthorized(&block)
        on('unauthorized', &block)
      end

      def on_forbidden(&block)
        on('forbidden', &block)
      end

      def on_not_found(&block)
        on('not_found', &block)
      end

      def on_not_acceptable(&block)
        on('not_acceptable', &block)
      end

      def on_too_long(&block)
        on('too_long', &block)
      end

      def on_range_unacceptable(&block)
        on('range_unacceptable', &block)
      end

      def on_enhance_your_calm(&block)
        on('enhance_your_calm', &block)
      end
      alias :on_rate_limited :on_enhance_your_calm

      def on_service_unavailable(&block)
        on('service_unavailable', &block)
      end

      def start
        @request = Request.new(@options)
        @io.stream(self)
      end

      def stop
      end

      def restart
      end

      def invoke_callback(callback, *args)
        @callbacks[callback.to_s].call(*args) if @callbacks[callback.to_s]
      end

      private

      def handle_response(response_body)
        # parse the response
        # determine what kind of message
        # invoke the callback for the response (if a callback exists)
      end

    end
  end
end
