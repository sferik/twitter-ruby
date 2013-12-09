source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'pry'
  gem 'pry-debugger', :platforms => :mri_19
  gem 'pry-rescue'
  gem 'pry-stack_explorer', :platforms => :mri_19
  gem 'redcarpet'
end

group :test do
  gem 'coveralls', :require => false
  gem 'mime-types', '~> 1.25', :platforms => :ruby_18
  gem 'rspec', '>= 2.14'
  gem 'simplecov', :require => false
  gem 'timecop', '0.6.1'
  gem 'webmock'
end

platforms :rbx do
  gem 'rubysl-singleton', '~> 2.0'
end

gemspec
