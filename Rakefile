require 'bundler'
Bundler::GemHelper.install_tasks

task :erd do
  `bundle exec ruby ./etc/erd.rb > ./etc/erd.dot`
  `dot -Tpng ./etc/erd.dot -o ./etc/erd.png`
  `open ./etc/erd.png`
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec

begin
  require 'rubocop/rake_task'
  Rubocop::RakeTask.new
rescue LoadError
  desc 'Run RuboCop'
  task :rubocop do
    $stderr.puts 'Rubocop is disabled'
  end
end

require 'yard'
YARD::Rake::YardocTask.new

task :default => [:spec, :rubocop]
