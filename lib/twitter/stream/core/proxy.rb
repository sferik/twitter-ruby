module Twitter
  module Stream
    class Proxy

      attr_reader :user, :password, :uri

      def initialize(options = {})
        @user     = options.delete(:user)
        @password = options.delete(:password)
        @uri      = options.delete(:uri)
      end

      def header
        ["#{@user}:#{@password}"].pack('m').delete("\r\n") if credentials?
      end

      private

      def credentials?
        @user && @password
      end
    end

  end
end
