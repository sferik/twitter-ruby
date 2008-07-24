module Twitter
  module CLI
    module Helpers
      def output_tweets(collection, options={})
        options.reverse_merge!({
          :cache        => false,
          :since_prefix => '',
          :empty_msg    => 'Nothing new since your last check.'
        })
        if collection.size > 0
          justify   = collection.collect { |s| s.user.screen_name }.max { |a,b| a.length <=> b.length }.length rescue 0
          indention = ' ' * (justify + 3)
          say("\n#{indention}#{collection.size} new tweet(s) found.\n\n")
          collection.each do |s|
            Tweet.create_from_tweet(current_account, s) if options[:cache]
            occurred_at    = Time.parse(s.created_at).strftime('On %b %d at %l:%M%P')
            formatted_time = '-' * occurred_at.length + "\n#{indention}#{occurred_at}"
            formatted_name = s.user.screen_name.rjust(justify + 1)
            formatted_msg  = ''
            s.text.split(' ').in_groups_of(6, false) { |row| formatted_msg += row.join(' ') + "\n#{indention}" }
            say "#{CGI::unescapeHTML(formatted_name)}: #{CGI::unescapeHTML(formatted_msg)}#{formatted_time}\n\n"
          end
          Configuration["#{options[:since_prefix]}_since_id"] = collection.first.id
        else
          say(options[:empty_msg])
        end
      end
      
      def base(username=current_account.username, password=current_account.password)
        @base ||= Twitter::Base.new(username, password)
      end
      
      def current_account
        @current_account ||= Account.active
        exit('No current account.') if @current_account.blank?
        @current_account
      end
                  
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