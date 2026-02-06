require "bundler"
Bundler::GemHelper.install_tasks
FORMAT = "svg".freeze

desc "Generate entity-relationship diagram"
task :erd do
  `bundle exec ruby ./etc/erd.rb > ./etc/erd.dot`
  `dot -T #{FORMAT} ./etc/erd.dot -o ./etc/erd.#{FORMAT}`
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Run specs"
task test: :spec

desc "Run mutant"
task :mutant do
  sh "bundle exec mutant"
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

require "yard"
YARD::Rake::YardocTask.new

require "yardstick/rake/measurement"
Yardstick::Rake::Measurement.new do |measurement|
  measurement.output = "measurement/report.txt"
end

require "yardstick/rake/verify"
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end

desc "Run Steep type checker"
task :steep do
  sh "bundle exec steep check"
end

task default: %i[spec rubocop verify_measurements steep]
