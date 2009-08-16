require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name              = "twitter"
    gem.summary           = %Q{wrapper for the twitter api (oauth only)}
    gem.email             = "nunemaker@gmail.com"
    gem.homepage          = "http://github.com/jnunemaker/twitter"
    gem.authors           = ["John Nunemaker"]
    gem.rubyforge_project = "twitter"
    gem.files             = FileList["[A-Z]*", "{examples,lib,test}/**/*"]
    
    gem.add_dependency('oauth', '>= 0.3.4')
    gem.add_dependency('mash', '0.0.3')
    gem.add_dependency('httparty', '0.4.3')
    
    gem.add_development_dependency('thoughtbot-shoulda')
    gem.add_development_dependency('jeremymcanally-matchy')
    gem.add_development_dependency('mocha')
    gem.add_development_dependency('fakeweb')
    gem.add_development_dependency('mash')
  end
  
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "twitter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

