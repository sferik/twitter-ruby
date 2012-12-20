source :rubygems

gem 'rake'
gem 'yard'

platforms :jruby do
  gem 'jruby-openssl', '~> 0.7'
end

group :test do
  gem 'json', :platforms => :ruby_18
  gem 'rspec'
  gem 'timecop'
  gem 'webmock'
end

gemspec
