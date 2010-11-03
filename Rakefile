require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Run all examples using rcov"
  RSpec::Core::RakeTask.new(:rcov => :cleanup_rcov_files) do |task|
    task.rcov = true
    task.rcov_opts = %[-Ilib -Ispec --exclude "gems/*,features,specs" --text-report --sort coverage]
  end
end

task :cleanup_rcov_files do
  rm_rf 'coverage'
end

task :default => ["spec:rcov"]

task :doc => [:yard]
namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new do |task|
    task.files   = ['HISTORY.mkd', 'LICENSE.mkd', 'lib/**/*.rb']
    task.options = [
      '--protected',
      '--output-dir', 'doc/yard',
      '--tag', 'format:Supported formats',
      '--tag', 'authenticated:Requires Authentication',
      '--tag', 'rate_limited:Rate Limited',
      '--markup', 'markdown',
    ]
  end
end

desc "Upload website files to rubyforge"
task :website do
  sh %{rsync -av website/ jnunemaker@rubyforge.org:/var/www/gforge-projects/twitter}
end
