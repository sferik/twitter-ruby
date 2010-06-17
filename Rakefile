require "rake"
require "jeweler"

Jeweler::Tasks.new do |gem|
  gem.name              = "twitter"
  gem.summary           = %Q{wrapper for the twitter api}
  gem.email             = "nunemaker@gmail.com"
  gem.homepage          = "http://github.com/jnunemaker/twitter"
  gem.authors           = ["John Nunemaker", "Wynn Netherland"]
  gem.files             = FileList["[A-Z]*", "{examples,lib,test}/**/*"]

  gem.add_dependency("oauth", "~> 0.4.1")
  gem.add_dependency("hashie", "~> 0.2.0")
  gem.add_dependency("httparty", "~> 0.5.0")
  gem.add_dependency("yajl-ruby", "~> 0.7.0")

  gem.add_development_dependency("shoulda", "~> 2.10.0")
  gem.add_development_dependency("jnunemaker-matchy", "~> 0.4.0")
  gem.add_development_dependency("mocha", "~> 0.9.0")
  gem.add_development_dependency("fakeweb", "~> 1.2.0")
  gem.add_development_dependency("redgreen", "~> 1.2.2")
end

Jeweler::GemcutterTasks.new

require "rake/testtask"
Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.ruby_opts << "-rubygems"
  test.pattern = "test/**/*_test.rb"
  test.verbose = true
end

task :default  => :test
task :test     => :check_dependencies

desc "Upload website files to rubyforge"
task :website do
  sh %{rsync -av website/ jnunemaker@rubyforge.org:/var/www/gforge-projects/twitter}
end
