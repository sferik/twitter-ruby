source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'pry'
  gem 'pry-rescue'
  platforms :ruby_19, :ruby_20 do
    gem 'pry-debugger'
    gem 'pry-stack_explorer'
    gem 'redcarpet'
  end
end

group :test do
  gem 'backports'
  gem 'coveralls', :require => false
  gem 'mime-types', '~> 1.25', :platforms => :ruby_18
  gem 'rspec', '>= 2.14'
  gem 'rubocop', '>= 0.15', :platforms => [:ruby_19, :ruby_20]
  gem 'simplecov', :require => false
  gem 'timecop', '0.6.1'
  gem 'webmock'
  gem 'yardstick'
end

platforms :rbx do
  gem 'rubinius-coverage', '~> 2.0'
  gem 'rubysl-base64', '~> 2.0'
  gem 'rubysl-bigdecimal', '~> 2.0'
  gem 'rubysl-net-http', '~> 2.0'
  gem 'rubysl-rexml', '~> 2.0'
  gem 'rubysl-singleton', '~> 2.0'
end

gemspec
