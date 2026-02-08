require "bundler"
require "etc"
Bundler::GemHelper.install_tasks
FORMAT = "svg".freeze

desc "Generate entity-relationship diagram"
task :erd do
  sh "bundle exec ruby ./etc/erd.rb > ./etc/erd.dot"
  sh "dot -T #{FORMAT} ./etc/erd.dot -o ./etc/erd.#{FORMAT}"
end

require "rake/testtask"
Rake::TestTask.new(:test) do |task|
  task.libs << "test"
  task.pattern = "test/**/*_test.rb"
  task.warning = false
end

desc "Run mutant"
task :mutant do
  jobs = [ENV.fetch("MUTANT_JOBS", Etc.nprocessors.to_s).to_i, 1].max
  label = (jobs == 1) ? "job" : "jobs"
  puts "Running mutant with #{jobs} #{label}"
  sh "bundle exec mutant run --jobs #{jobs}"
end

require "rubocop/rake_task"
RuboCop::RakeTask.new

require "standard/rake"

desc "Run lint checks"
task lint: %i[standard rubocop]

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

task default: %i[test rubocop verify_measurements mutant steep]
