# encoding: utf-8
require File.expand_path('../lib/twitter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'hashie', '~> 1.1.0'
  gem.add_dependency 'faraday', '~> 0.7.4'
  gem.add_dependency 'faraday_middleware', '~> 0.7.0'
  gem.add_dependency 'multi_json', '~> 1.0.0'
  gem.add_dependency 'multi_xml', '~> 0.4.0'
  gem.add_dependency 'simple_oauth', '~> 0.1.5'
  gem.add_development_dependency 'nokogiri', '~> 1.4'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rdiscount', '~> 1.6'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'webmock', '~> 1.7'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.authors = ["John Nunemaker", "Wynn Netherland", "Erik Michaels-Ober", "Steve Richert"]
  gem.description = %q{A Ruby wrapper for the Twitter REST and Search APIs}
  gem.email = ['nunemaker@gmail.com', 'wynn.netherland@gmail.com', 'sferik@gmail.com', 'steve.richert@gmail.com']
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files = `git ls-files`.split("\n")
  gem.homepage = 'https://github.com/jnunemaker/twitter'
  gem.name = 'twitter'
  gem.post_install_message =<<eos
********************************************************************************

  Follow @gem on Twitter for announcements, updates, and news.
  https://twitter.com/gem

  Join the mailing list!
  https://groups.google.com/group/ruby-twitter-gem

  Add your project or organization to the apps wiki!
  https://github.com/jnunemaker/twitter/wiki/apps

********************************************************************************
eos
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  gem.summary = %q{Ruby wrapper for the Twitter API}
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = Twitter::VERSION.dup
end
