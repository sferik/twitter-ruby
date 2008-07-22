module Twitter
  module CLI
    module Helpers            
      def do_work(&block)
        connect
        begin
          block.call
        rescue Twitter::RateExceeded
          say("Twitter says you've been making too many requests. Wait for a bit and try again.")
        rescue Twitter::Unavailable
          say("Twitter is unavailable right now. Try again later.")
        rescue Twitter::CantConnect => msg
          say("Can't connect to twitter because: #{msg}")
        end
      end
      
      def connect
        ActiveRecord::Base.logger = Logger.new('/tmp/twitter_ar_logger.log')
        ActiveRecord::Base.establish_connection(Twitter::CLI::Config)
        ActiveRecord::Base.connection
      end

      def migrate
        connect
        ActiveRecord::Migrator.migrate("#{CLI_ROOT}/migrations/")
      end

      def connect_and_migrate
        say('Attempting to establish connection...')
        connect
        say('Connection established...migrating database...')
        migrate
      end
    end
  end
end