require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'hoe'
include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'twitter', 'version')

AUTHOR = "John Nunemaker"  # can also be an array of Authors
EMAIL = "nunemaker@gmail.com"
DESCRIPTION = "a command line interface for twitter, also a library which wraps the twitter api"
GEM_NAME = "twitter" # what ppl will type to install your gem
RUBYFORGE_PROJECT = "twitter" # The unix name for your project
HOMEPATH = "http://#{RUBYFORGE_PROJECT}.rubyforge.org"
RELEASE_TYPES = %w( gem ) # can use: gem, tar, zip


NAME = "twitter"
REV = nil # UNCOMMENT IF REQUIRED: File.read(".svn/entries")[/committed-rev="(d+)"/, 1] rescue nil
VERS = ENV['VERSION'] || (Twitter::VERSION::STRING + (REV ? ".#{REV}" : ""))
CLEAN.include ['**/.*.sw?', '*.gem', '.config']
RDOC_OPTS = ['--quiet', '--title', "twitter documentation",
  "--opname", "index.html",
  "--line-numbers", 
  "--main", "README",
  "--inline-source"]

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
hoe = Hoe.new(GEM_NAME, VERS) do |p|
  p.author         = AUTHOR 
  p.description    = DESCRIPTION
  p.email          = EMAIL
  p.summary        = DESCRIPTION
  p.url            = HOMEPATH
  p.rubyforge_name = RUBYFORGE_PROJECT if RUBYFORGE_PROJECT
  p.test_globs     = ["test/**/*_test.rb"]
  p.clean_globs    = CLEAN  #An array of file patterns to delete on clean.
  
  # == Optional
  #p.changes        - A description of the release's latest changes.
  p.extra_deps = %w( hpricot )
  #p.spec_extras    - A hash of extra values to set in the gemspec.
end

desc 'Publish HTML to RubyForge'
task :publish_html do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  remote_dir = "/var/www/gforge-projects/snitch/"
  local_dir = 'html'
  sh %{rsync -av --delete #{local_dir}/ #{host}:#{remote_dir}}
  `rake publish_docs`
end