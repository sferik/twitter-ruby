source 'https://rubygems.org'

gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'kramdown'
  gem 'pry'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'pry-debugger', :platforms => :mri_19
end

group :test do
  gem 'coveralls', :require => false
  gem 'json', :platforms => :ruby_18
  gem 'rspec', '>= 2.14'
  gem 'simplecov', :require => false
  gem 'timecop'
  gem 'webmock'
end

gemspec
