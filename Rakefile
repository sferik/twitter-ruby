require 'bundler'
Bundler::GemHelper.install_tasks

task :erd do
  FORMAT = 'svg'.freeze
  `bundle exec ruby ./etc/erd.rb > ./etc/erd.dot`
  `dot -T #{FORMAT} ./etc/erd.dot -o ./etc/erd.#{FORMAT}`
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
  verify.threshold = 58.7
end

task default: %i[spec rubocop verify_measurements]
