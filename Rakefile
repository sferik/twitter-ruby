require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration

Dir['tasks/**/*.rake'].each { |rake| load rake }

task :build_gemspec_filelist do
  files = File.read(File.join(File.dirname(__FILE__), 'Manifest.txt')).split("\n")
  puts
  puts files.inspect
  puts
end