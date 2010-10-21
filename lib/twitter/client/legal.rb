module Twitter
  class Client
    module Legal
      def tos(options={})
        get('legal/tos', options)
      end

      def privacy(options={})
        get('legal/privacy', options)
      end
    end
  end
end
