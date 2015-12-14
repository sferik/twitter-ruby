source 'https://rubygems.org'

gem 'addressable', '~> 2.3.8', :platforms => [:jruby, :ruby_18]
gem 'jruby-openssl', :platforms => :jruby
gem 'rake'
gem 'yard'

group :development do
  gem 'pry'
  platforms :ruby_19, :ruby_20, :ruby_21 do
    gem 'pry-stack_explorer'
    gem 'redcarpet'
  end
end

group :test do
  gem 'backports'
  gem 'coveralls'
  gem 'mime-types', '~> 1.25', :platforms => [:jruby, :ruby_18]
  gem 'rest-client', '~> 1.6.0', :platforms => [:jruby, :ruby_18]
  gem 'rspec', '>= 2.14'
  gem 'rubocop', '>= 0.27', :platforms => [:ruby_19, :ruby_20, :ruby_21]
  gem 'simplecov', '>= 0.9'
  gem 'timecop', '0.6.1'
  gem 'webmock'
  gem 'yardstick'
end

gemspec
