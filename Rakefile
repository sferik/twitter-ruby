require 'bundler'
Bundler::GemHelper.install_tasks

task :erd do
  `bundle exec ruby ./etc/erd.rb > ./etc/erd.dot`
  `dot -Tpng ./etc/erd.dot -o ./etc/erd.png`
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task test: :spec

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'yard'
YARD::Rake::YardocTask.new

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new do |measurement|
  measurement.output = 'measurement/report.txt'
end

require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 59.5
  verify.require_exact_threshold = false
end

task default: [:spec, :rubocop, :verify_measurements]
