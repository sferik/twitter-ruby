module Twitter
  module CLI
    Config = {
      :adapter => 'sqlite3', 
      :database => File.join(ENV['HOME'], '.twitter.db'), 
      :timeout => 5000
    }
  end
end