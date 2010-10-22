module Twitter
  class Client
    module Help
      def test(options={})
        get('help/test', options)
      end
    end
  end
end
