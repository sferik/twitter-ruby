module Twitter
  module Cli

    class ClientProxy < Twitter::Client
      [:get, :post, :put, :delete].each do |http_method|
        class_eval %Q[
        def #{http_method}(*args)
          super(*args)[:body]
        end]
      end
    end

    BANNER  = "Twitter CLI -- Type `usage` for examples."
    USAGE   = %Q{
    Fetch a user
    api.get('/1/users/show.json?screen_name=<screen_name>')

    Image uploads
    image = File.open("/path/to/banner.png")
    api.post('/1/account/profile_banner.json', :banner => image)

    }.gsub(/^\t{4}/,'')

    def usage
      print USAGE
    end

    def endpoint
      ENV['TWITTER_API_ENDPOINT'] || Twitter::Default::ENDPOINT
    end

    def api
      @api ||= ClientProxy.new(:endpoint => endpoint)
    end

    def start
      puts BANNER

      IRB.setup(nil)
      irb = IRB::Irb.new

      IRB.conf[:MAIN_CONTEXT] = irb.context

      irb.context.evaluate("require 'irb/completion'", 0)

      trap("SIGINT") do
        irb.signal_handle
      end

      catch(:IRB_EXIT) do
        irb.eval_input
      end
    end
  end
end
