require 'rubygems'
gem 'main', '>= 2.8.2'
gem 'highline', '>= 1.4.0'
gem 'activerecord', '>= 2.1.0'
gem 'sqlite3-ruby', '>= 1.2.2'
require 'main'
require 'highline/import'
require 'activerecord'
require 'sqlite3'

HighLine.track_eof = false
CLI_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'cli'))
require CLI_ROOT + '/config'
require CLI_ROOT + '/helpers'
Dir[CLI_ROOT + '/models/*.rb'].each { |m| require m }

include Twitter::CLI::Helpers

Main {
  def run
    puts "twitter [command] --help for usage instructions."
    puts "The available commands are: \n   install, uninstall, add, remove, list, change, post, befriend, defriend, follow, leave, d and timeline."
  end
  
  mode 'install' do
    description 'Creates the sqlite3 database and runs the migrations.'
    def run
      migrate
      say 'Twitter installed.'
    end
  end
  
  mode 'uninstall' do
    description 'Removes the sqlite3 database. There is no undo for this.'
    def run
      FileUtils.rm(Twitter::CLI::Config[:database])
      say 'Twitter gem uninstalled.'
    end
  end
  
  mode 'add' do
    description 'Adds a new twitter account to the database. Prompts for username and password.'
    def run
      account = Hash.new
      say "Add New Account:"

      account[:username] = ask('Username: ') do |q|
        q.validate = /\S+/
      end

      account[:password] = ask("Password (won't be displayed): ") do |q|
        q.echo = false
        q.validate = /\S+/
      end
      
      do_work do
        base(account[:username], account[:password]).verify_credentials
        account[:current] = Account.current.count > 0 ? false : true
        Account.create(account)
        say 'Account added.'
      end
    end
  end
  
  mode 'remove' do
    description 'Removes a twitter account from the database. If username provided it removes that username else it prompts with list and asks for which one you would like to remove.'
    argument( 'username' ) { 
      optional
      description 'username of account you would like to remove' 
    }
    
    def run
      do_work do
        if params['username'].given?
          account = Account.find_by_username(params['username'].value)
        else
          Account.find(:all, :order => 'username').each do |a|
            say "#{a.id}. #{a}"
          end
          account_id = ask 'Account to remove (enter number): ' do |q|
            q.validate = /\d+/
          end
        end
        
        begin
          account = account_id ? Account.find(account_id) : account
          account_name = account.username
          account.destroy
          say "#{account_name} has been removed.\n"
        rescue ActiveRecord::RecordNotFound
          say "ERROR: Account could not be found. Try again. \n"
        end
        
      end
    end
  end
  
  mode 'list' do
    description 'Lists all the accounts that have been added and puts a * by the current one that is used for posting, etc.'
    def run
      do_work do
        if Account.count == 0
          say 'No accounts have been added.' 
        else
          say 'Account List'
          Account.find(:all, :order => 'username').each do |a|
            say a 
          end
        end
      end
    end
  end
  
  mode 'change' do
    description 'Changes the current account being used for posting etc. to the username provided. If no username is provided, a list is presented and you can choose the account from there.'
    argument( 'username' ) { 
      optional
      description 'username of account you would like to switched to' 
    }
    
    def run
      do_work do
        if params['username'].given?
          new_current = Account.find_by_username(params['username'].value)
        else
          Account.find(:all, :order => 'username').each do |a|
            say "#{a.id}. #{a}"
          end
          new_current = ask 'Change current account to (enter number): ' do |q|
            q.validate = /\d+/
          end
        end
        
        begin
          current = Account.set_current(new_current)
          say "#{current} is now the current account.\n"
        rescue ActiveRecord::RecordNotFound
          say "ERROR: Account could not be found. Try again. \n"
        end
      end
    end
  end
  
  mode 'post' do
    description "Posts a message to twitter using the current account. The following are all valid examples from the command line:
    $ twitter post 'my update'
    $ twitter post my update with quotes
    $ echo 'my update from stdin' | twitter post"
    def run
      do_work do
        post = ARGV.size > 1 ? ARGV.join(" ") : ARGV.shift
        say "Sending twitter update"
        finished, status = false, nil
        progress_thread = Thread.new { until finished; print "."; $stdout.flush; sleep 0.5; end; }
        post_thread = Thread.new(binding()) do |b|
          status = base.post(post, :source => Twitter::SourceName)
          finished = true
        end
        post_thread.join
        progress_thread.join
        say "Got it! New twitter created at: #{status.created_at}\n"
      end
    end
  end

  mode 'befriend' do
    description "Allows you to add a user as a friend"
    argument('username') {
      required
      description 'username or id of twitterrer to befriend'
    }

    def run
      do_work do
        username = params['username'].value
        base.create_friendship(username)
        say "#{username} has been added as a friend. follow notifications with 'twitter follow #{username}'"
      end
    end
  end

  mode 'defriend' do
    description "Allows you to remove a user from being a friend"
    argument('username') {
      required
      description 'username or id of twitterrer to defriend'
    }

    def run
      do_work do
        username = params['username'].value
        base.destroy_friendship(username)
        say "#{username} has been removed from your friends"
      end
    end
  end
  
  mode 'follow' do
    description "Allows you to turn on notifications for a user"
    argument('username') {
      required
      description 'username or id of twitterrer to follow'
    }
    
    def run
      do_work do
        username = params['username'].value
        base.follow(username)
        say "You are now following notifications from #{username}"
      end
    end
  end
  
  mode 'leave' do
    description "Allows you to turn off notifications for a user"
    argument('username') {
      required
      description 'username or id of twitterrer to leave'
    }
    
    def run
      do_work do
        username = params['username'].value
        base.leave(username)
        say "You are no longer following notifications from #{username}"
      end
    end
  end
  
  mode 'd' do
    description "Allows you to direct message a user. The following are all valid examples from the command line:
    $ twitter d jnunemaker 'yo homeboy'
    $ twitter d jnunemaker yo homeboy
    $ echo 'yo homeboy' | twitter d jnunemaker"
    argument('username') {
      required
      description 'username or id of twitterrer to direct message'
    }
    
    def run
      do_work do
        username = params['username'].value
        post = ARGV.size > 1 ? ARGV.join(" ") : ARGV.shift
        base.d(username, post)
        say "Direct message sent to #{username}"
      end
    end
  end
  
  mode 'timeline' do
    description "Allows you to view your timeline, your friends or the public one"
    argument( 'timeline' ) {
      description 'the timeline you wish to see (friends, public, me)'
      default 'friends'
    }
    
    def run
      do_work do
        timeline = params['timeline'].value == 'me' ? 'user' : params['timeline'].value
        base.timeline(timeline.to_sym).each do |s|
          Tweet.create_from_tweet(current_account, s) if timeline != :public
          say "#{CGI::unescapeHTML(s.text)}\n --\e[34m #{CGI::unescapeHTML(s.user.name)}\e[32m at #{s.created_at}" 
          say "\e[0m"
        end
      end
    end
  end
}
