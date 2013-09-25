require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

task :erd do
  `bundle exec ruby ./etc/erd.rb > ./etc/erd.dot`
  `dot -Tpng ./etc/erd.dot -o ./etc/erd.png`
  `open ./etc/erd.png`
end

require 'yard'
YARD::Rake::YardocTask.new
