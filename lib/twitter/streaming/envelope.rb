module Twitter
  module Streaming
    class Envelope
      attr_reader :for_user, :message

      def initialize(attrs)
        @for_user = attrs[:for_user]
        @message = MessageParser.parse(attrs[:message])
      end
    end
  end
end
